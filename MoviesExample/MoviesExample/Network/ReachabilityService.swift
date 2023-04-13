//
//  ReachabilityService.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import UIKit
import VATextureKit

// MARK: - Copied from Alamofire

// swiftlint:disable file_length
public enum ReachabilityStatus {
    case notReachable
    case reachable
}

public final class ReachabilityService {
    public static let shared = ReachabilityService()
    /// key to send notification by changing the status of the network
    public static let reachabilityStatusChanged = NSNotification.Name(rawValue: "NSNotificationKeyReachabilityStatusChanged")

    /// reachability status
    public private(set) var reachabilityStatus: ReachabilityStatus = .reachable
    @Obs.Relay(value: true)
    public var isConnectionOnlineObs: Observable<Bool>

    /// Alamofire (NetworkReachabilityManager)
    private let networkManager = NetworkReachabilityManager()

    // MARK: check network

    /// checking internet connection
    ///
    /// - returns: network status
    public var isConnected: Bool {
        switch networkManager?.status {
        case .notReachable, .unknown, .none:
            return false
        default:
            return true
        }
    }

    // MARK: - listening

    public func startListening() {
        networkManager?.startListening { status in
            let reachabilityStatus: ReachabilityStatus = {
                switch status {
                case .reachable(.cellular):
                    return .reachable
                case .reachable(.ethernetOrWiFi):
                    return .reachable
                case .notReachable:
                    return .notReachable
                case .unknown:
                    return .notReachable
                }
            }()

            /// - unknown:      It is unknown whether the network is reachable.
            /// - notReachable: The network is not reachable.
            /// - reachable:    The network is reachable.
            NotificationCenter.default.post(
                name: Self.reachabilityStatusChanged,
                object: nil,
                userInfo: ["status": reachabilityStatus]
            )
            self.offlineMode(reachabilityStatus: reachabilityStatus)
        }
    }

    public func stopListening() {
        networkManager?.stopListening()
    }

    private func offlineMode(reachabilityStatus: ReachabilityStatus) {
        if self.reachabilityStatus == reachabilityStatus {
            return
        }
        self.reachabilityStatus = reachabilityStatus
        switch reachabilityStatus {
        case .notReachable:
            _isConnectionOnlineObs.rx.accept(false)
            NotificationCenter.default.post(Notification.errorInternetConection)
        case .reachable:
            _isConnectionOnlineObs.rx.accept(true)
            NotificationCenter.default.post(Notification.successInternetConection)
        }
    }
}

public extension Notification {
    static var errorInternetConection: Notification { Notification(name: .errorInternetConection) }
    static var successInternetConection: Notification { Notification(name: .successInternetConection) }
}

public extension Notification.Name {
    static var errorInternetConection: Notification.Name { Notification.Name("com.vandrj.errorInternetConection") }
    static var successInternetConection: Notification.Name { Notification.Name("com.vandrj.successInternetConection") }
}

#if !(os(watchOS) || os(Linux) || os(Windows))

import Foundation
import SystemConfiguration

/// The `NetworkReachabilityManager` class listens for reachability changes of hosts and addresses for both cellular and
/// WiFi network interfaces.
///
/// Reachability can be used to determine background information about why a network operation failed, or to retry
/// network requests when a connection is established. It should not be used to prevent a user from initiating a network
/// request, as it's possible that an initial request may be required to establish reachability.
open class NetworkReachabilityManager {
    /// Defines the various states of network reachability.
    public enum NetworkReachabilityStatus {
        /// It is unknown whether the network is reachable.
        case unknown
        /// The network is not reachable.
        case notReachable
        /// The network is reachable on the associated `ConnectionType`.
        case reachable(ConnectionType)

        init(_ flags: SCNetworkReachabilityFlags) {
            guard flags.isActuallyReachable else { self = .notReachable; return }

            var networkStatus: NetworkReachabilityStatus = .reachable(.ethernetOrWiFi)

            if flags.isCellular { networkStatus = .reachable(.cellular) }

            self = networkStatus
        }

        /// Defines the various connection types detected by reachability flags.
        public enum ConnectionType {
            /// The connection type is either over Ethernet or WiFi.
            case ethernetOrWiFi
            /// The connection type is a cellular connection.
            case cellular
        }
    }

    /// A closure executed when the network reachability status changes. The closure takes a single argument: the
    /// network reachability status.
    public typealias Listener = (NetworkReachabilityStatus) -> Void

    /// Default `NetworkReachabilityManager` for the zero address and a `listenerQueue` of `.main`.
    public static let `default` = NetworkReachabilityManager()

    // MARK: - Properties
    /// Whether the network is currently reachable.
    open var isReachable: Bool { isReachableOnCellular || isReachableOnEthernetOrWiFi }

    /// Whether the network is currently reachable over the cellular interface.
    ///
    /// - Note: Using this property to decide whether to make a high or low bandwidth request is not recommended.
    ///         Instead, set the `allowsCellularAccess` on any `URLRequest`s being issued.
    ///
    open var isReachableOnCellular: Bool { status == .reachable(.cellular) }

    /// Whether the network is currently reachable over Ethernet or WiFi interface.
    open var isReachableOnEthernetOrWiFi: Bool { status == .reachable(.ethernetOrWiFi) }

    /// `DispatchQueue` on which reachability will update.
    public let reachabilityQueue = DispatchQueue(label: "org.alamofire.reachabilityQueue")

    /// Flags of the current reachability type, if any.
    open var flags: SCNetworkReachabilityFlags? {
        var flags = SCNetworkReachabilityFlags()

        return (SCNetworkReachabilityGetFlags(reachability, &flags)) ? flags : nil
    }

    /// The current network reachability status.
    open var status: NetworkReachabilityStatus {
        flags.map(NetworkReachabilityStatus.init) ?? .unknown
    }

    /// Mutable state storage.
    struct MutableState {
        /// A closure executed when the network reachability status changes.
        var listener: Listener?
        /// `DispatchQueue` on which listeners will be called.
        var listenerQueue: DispatchQueue?
        /// Previously calculated status.
        var previousStatus: NetworkReachabilityStatus?
    }

    /// `SCNetworkReachability` instance providing notifications.
    private let reachability: SCNetworkReachability

    /// Protected storage for mutable state.
    @Protected
    private var mutableState = MutableState()

    // MARK: - Initialization
    /// Creates an instance with the specified host.
    ///
    /// - Note: The `host` value must *not* contain a scheme, just the hostname.
    ///
    /// - Parameters:
    ///   - host:          Host used to evaluate network reachability. Must *not* include the scheme (e.g. `https`).
    public convenience init?(host: String) {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else { return nil }

        self.init(reachability: reachability)
    }

    /// Creates an instance that monitors the address 0.0.0.0.
    ///
    /// Reachability treats the 0.0.0.0 address as a special token that causes it to monitor the general routing
    /// status of the device, both IPv4 and IPv6.
    public convenience init?() {
        var zero = sockaddr()
        zero.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zero.sa_family = sa_family_t(AF_INET)

        guard let reachability = SCNetworkReachabilityCreateWithAddress(nil, &zero) else { return nil }

        self.init(reachability: reachability)
    }

    private init(reachability: SCNetworkReachability) {
        self.reachability = reachability
    }

    deinit {
        stopListening()
    }

    // MARK: - Listening
    /// Starts listening for changes in network reachability status.
    ///
    /// - Note: Stops and removes any existing listener.
    ///
    /// - Parameters:
    ///   - queue:    `DispatchQueue` on which to call the `listener` closure. `.main` by default.
    ///   - listener: `Listener` closure called when reachability changes.
    ///
    /// - Returns: `true` if listening was started successfully, `false` otherwise.
    @discardableResult
    open func startListening(
        onQueue queue: DispatchQueue = .main,
        onUpdatePerforming listener: @escaping Listener
    ) -> Bool {
        stopListening()

        $mutableState.write { state in
            state.listenerQueue = queue
            state.listener = listener
        }

        var context = SCNetworkReachabilityContext(
            version: 0,
            info: Unmanaged.passUnretained(self).toOpaque(),
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        let callback: SCNetworkReachabilityCallBack = { _, flags, info in
            guard let info else {
                return
            }

            let instance = Unmanaged<NetworkReachabilityManager>.fromOpaque(info).takeUnretainedValue()
            instance.notifyListener(flags)
        }

        let queueAdded = SCNetworkReachabilitySetDispatchQueue(reachability, reachabilityQueue)
        let callbackAdded = SCNetworkReachabilitySetCallback(reachability, callback, &context)

        // Manually call listener to give initial state, since the framework may not.
        if let flags {
            reachabilityQueue.async {
                self.notifyListener(flags)
            }
        }

        return callbackAdded && queueAdded
    }

    /// Stops listening for changes in network reachability status.
    open func stopListening() {
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        $mutableState.write { state in
            state.listener = nil
            state.listenerQueue = nil
            state.previousStatus = nil
        }
    }

    // MARK: - Internal - Listener Notification
    /// Calls the `listener` closure of the `listenerQueue` if the computed status hasn't changed.
    ///
    /// - Note: Should only be called from the `reachabilityQueue`.
    ///
    /// - Parameter flags: `SCNetworkReachabilityFlags` to use to calculate the status.
    func notifyListener(_ flags: SCNetworkReachabilityFlags) {
        let newStatus = NetworkReachabilityStatus(flags)

        $mutableState.write { state in
            guard state.previousStatus != newStatus else { return }

            state.previousStatus = newStatus

            let listener = state.listener
            state.listenerQueue?.async { listener?(newStatus) }
        }
    }
}

// MARK: -
extension NetworkReachabilityManager.NetworkReachabilityStatus: Equatable {}

extension SCNetworkReachabilityFlags {
    var isReachable: Bool { contains(.reachable) }
    var isConnectionRequired: Bool { contains(.connectionRequired) }
    var canConnectAutomatically: Bool { contains(.connectionOnDemand) || contains(.connectionOnTraffic) }
    var canConnectWithoutUserInteraction: Bool { canConnectAutomatically && !contains(.interventionRequired) }
    var isActuallyReachable: Bool { isReachable && (!isConnectionRequired || canConnectWithoutUserInteraction) }
    var isCellular: Bool {
        #if os(iOS) || os(tvOS)
        return contains(.isWWAN)
        #else
        return false
        #endif
    }

    /// Human readable `String` for all states, to help with debugging.
    // swiftlint:disable identifier_name
    var readableDescription: String {
        let W = isCellular ? "W" : "-"
        let R = isReachable ? "R" : "-"
        let c = isConnectionRequired ? "c" : "-"
        let t = contains(.transientConnection) ? "t" : "-"
        let i = contains(.interventionRequired) ? "i" : "-"
        let C = contains(.connectionOnTraffic) ? "C" : "-"
        let D = contains(.connectionOnDemand) ? "D" : "-"
        let l = contains(.isLocalAddress) ? "l" : "-"
        let d = contains(.isDirect) ? "d" : "-"
        let a = contains(.connectionAutomatic) ? "a" : "-"

        return "\(W)\(R) \(c)\(t)\(i)\(C)\(D)\(l)\(d)\(a)"
    }
}

private protocol Lock {
    func lock()
    func unlock()
}

extension Lock {
    /// Executes a closure returning a value while acquiring the lock.
    ///
    /// - Parameter closure: The closure to run.
    ///
    /// - Returns:           The value the closure generated.
    func around<T>(_ closure: () throws -> T) rethrows -> T {
        lock(); defer { unlock() }
        return try closure()
    }

    /// Execute a closure while acquiring the lock.
    ///
    /// - Parameter closure: The closure to run.
    func around(_ closure: () throws -> Void) rethrows {
        lock(); defer { unlock() }
        try closure()
    }
}

#if os(Linux) || os(Windows)

extension NSLock: Lock {}

#endif

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
/// An `os_unfair_lock` wrapper.
final class UnfairLock: Lock {
    private let unfairLock: os_unfair_lock_t

    init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }

    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }

    func lock() {
        os_unfair_lock_lock(unfairLock)
    }

    func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
}
#endif

/// A thread-safe wrapper around a value.
@propertyWrapper
@dynamicMemberLookup
final class Protected<T> {
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    private let lock = UnfairLock()
#elseif os(Linux) || os(Windows)
    private let lock = NSLock()
#endif
    private var value: T

    init(_ value: T) {
        self.value = value
    }

    /// The contained value. Unsafe for anything more than direct read or write.
    var wrappedValue: T {
        get { lock.around { value } }
        set { lock.around { value = newValue } }
    }

    var projectedValue: Protected<T> { self }

    init(wrappedValue: T) {
        value = wrappedValue
    }

    /// Synchronously read or transform the contained value.
    ///
    /// - Parameter closure: The closure to execute.
    ///
    /// - Returns:           The return value of the closure passed.
    func read<U>(_ closure: (T) throws -> U) rethrows -> U {
        try lock.around { try closure(self.value) }
    }

    /// Synchronously modify the protected value.
    ///
    /// - Parameter closure: The closure to execute.
    ///
    /// - Returns:           The modified value.
    @discardableResult
    func write<U>(_ closure: (inout T) throws -> U) rethrows -> U {
        try lock.around { try closure(&self.value) }
    }

    subscript<Property>(dynamicMember keyPath: WritableKeyPath<T, Property>) -> Property {
        get { lock.around { value[keyPath: keyPath] } }
        set { lock.around { value[keyPath: keyPath] = newValue } }
    }

    subscript<Property>(dynamicMember keyPath: KeyPath<T, Property>) -> Property {
        lock.around { value[keyPath: keyPath] }
    }
}
#endif
