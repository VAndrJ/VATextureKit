//
//  DispatchQueue+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 24.04.2023.
//

import Foundation

@preconcurrency public func mainAsync(
    after: DispatchTimeInterval,
    @_implicitSelfCapture _ block: @escaping @Sendable @convention(block) () -> Void
) {
    if let timeInterval = after.timeInterval {
        mainAsync(after: timeInterval, block)
    }
}

@preconcurrency public func mainAsync(
    after: TimeInterval = 0,
    @_implicitSelfCapture _ block: @escaping @Sendable @convention(block) () -> Void
) {
    if after > 0 {
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: block)
    } else {
        DispatchQueue.main.async(execute: block)
    }
}

@preconcurrency public func ensureOnMain(
    @_implicitSelfCapture _ block: @escaping @Sendable @convention(block) () -> Void
) {
    if Thread.current.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}

public func mainActorAsync(
    after: DispatchTimeInterval,
    @_implicitSelfCapture _ block: @MainActor @escaping @Sendable @convention(block) () -> Void
) {
    if let timeInterval = after.timeInterval {
        mainActorAsync(after: timeInterval, block)
    }
}

public func mainActorAsync(
    after: TimeInterval = 0,
    @_implicitSelfCapture _ block: @MainActor @escaping @Sendable @convention(block) () -> Void
) {
    if after > 0 {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            MainActor.assumeIsolated {
                block()
            }
        }
    } else {
        DispatchQueue.main.async {
            MainActor.assumeIsolated {
                block()
            }
        }
    }
}

public func ensureOnMainActor(
    @_implicitSelfCapture _ block: @MainActor @escaping @Sendable @convention(block) () -> Void
) {
    if Thread.current.isMainThread {
        MainActor.assumeIsolated {
            block()
        }
    } else {
        DispatchQueue.main.async {
            MainActor.assumeIsolated {
                block()
            }
        }
    }
}

private let key = DispatchSpecificKey<QueueValue>()

private let globalQueueValue = QueueValue()
private let globalQueue: DispatchQueue = {
    let queue = DispatchQueue(label: "globalQueue", qos: .default)
    queue.setSpecific(key: key, value: globalQueueValue)

    return queue
}()

@preconcurrency public func ensureOnGlobal(
    @_implicitSelfCapture _ block: @escaping @Sendable @convention(block) () -> Void
) {
    if DispatchQueue.getSpecific(key: key) === globalQueueValue {
        block()
    } else {
        globalQueue.async(execute: block)
    }
}

private let backgroundQueueValue = QueueValue()
private let backgroundQueue: DispatchQueue = {
    let queue = DispatchQueue(label: "backgroundQueue", qos: .background)
    queue.setSpecific(key: key, value: backgroundQueueValue)
    
    return queue
}()

@preconcurrency public func ensureOnBackground(
    @_implicitSelfCapture _ block: @escaping @Sendable @convention(block) () -> Void
) {
    if DispatchQueue.getSpecific(key: key) === backgroundQueueValue {
        block()
    } else {
        backgroundQueue.async(execute: block)
    }
}

public extension DispatchTimeInterval {
    var timeInterval: TimeInterval? {
        switch self {
        case let .seconds(value):
            return TimeInterval(value)
        case let .milliseconds(value):
            return TimeInterval(value) / 1_000
        case let .microseconds(value):
            return TimeInterval(value) / 1_000_000
        case let .nanoseconds(value):
            return TimeInterval(value) / 1_000_000_000
        case .never:
            return nil
        @unknown default:
            #if DEBUG
            assertionFailure()
            #endif
            
            return nil
        }
    }
}

private final class QueueValue: NSObject, Sendable {}
