import Foundation

/// A property wrapper granting atomic write access to the wrapped property.
/// Atomic mutation (read-modify-write) can be done using the wrapper `mutate` method.
/// Reading access is not atomic but is exclusive with write & mutate operations.
///
/// - Note: Getting and then setting is not an atomic operation. It is easy to unknowingly
/// trigger a get & a set, e.g.  when increasing a counter `count += 1`. Sadly such an atomic
/// modification cannot be simply done with getters and setter, hence we expose  the
/// `mutate(_ action: (inout Value) -> Void)`  method on the wrapper for this
/// purpose which you can access with a _ prefix.
///
/// ```
/// @Atomic var count = 0
///
/// // You can atomically write (non-derived) values directly:
/// count = 100
///
/// // To mutate (read-modify-write) always use the wrapper method:
/// _count.mutate { $0 += 1 }
///
/// print(count) // 101
/// ```
///
/// Some related reads & inspiration:
/// [swift-evolution proposal](https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md)
/// [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveSwift/blob/master/Sources/Atomic.swift)
/// [obj.io](https://www.objc.io/blog/2019/01/15/atomic-variables-part-2/)
@propertyWrapper
public struct AtomicWrite<Value> {
    public var wrappedValue: Value {
        get { queue.sync { value } }
        set { queue.sync(flags: .barrier) { value = newValue } }
    }

    let queue = DispatchQueue(label: "Atomic write access queue", attributes: .concurrent)
    var value: Value

    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    /// Atomically mutate the variable (read-modify-write).
    ///
    /// - parameter action: A closure executed with atomic in-out access to the wrapped property.
    public mutating func mutate(_ mutation: (inout Value) throws -> Void) rethrows {
        try queue.sync(flags: .barrier) {
            try mutation(&value)
        }
    }
}
