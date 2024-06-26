//
//  DispatchQueue+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 24.04.2023.
//

import Foundation

public func mainAsync(after: DispatchTimeInterval, @_implicitSelfCapture _ block: @escaping () -> Void) {
    if let timeInterval = after.timeInterval {
        mainAsync(after: timeInterval, block)
    }
}

public func mainAsync(after: TimeInterval = 0, @_implicitSelfCapture _ block: @escaping () -> Void) {
    if after > 0 {
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: block)
    } else {
        DispatchQueue.main.async(execute: block)
    }
}

public func ensureOnMain(@_implicitSelfCapture _ block: @escaping () -> Void) {
    if Thread.current.isMainThread {
        block()
    } else {
        DispatchQueue.main.async(execute: block)
    }
}

private let key = DispatchSpecificKey<NSObject>()

private let globalQueueValue = NSObject()
private let globalQueue: DispatchQueue = {
    let queue = DispatchQueue(label: "globalQueue", qos: .default)
    queue.setSpecific(key: key, value: globalQueueValue)

    return queue
}()

public func ensureOnGlobal(@_implicitSelfCapture _ block: @escaping () -> Void) {
    if DispatchQueue.getSpecific(key: key) === globalQueueValue {
        block()
    } else {
        globalQueue.async(execute: block)
    }
}

private let backgroundQueueValue = NSObject()
private let backgroundQueue: DispatchQueue = {
    let queue = DispatchQueue(label: "backgroundQueue", qos: .background)
    queue.setSpecific(key: key, value: backgroundQueueValue)
    
    return queue
}()

public func ensureOnBackground(@_implicitSelfCapture _ block: @escaping () -> Void) {
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
