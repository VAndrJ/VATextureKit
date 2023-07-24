//
//  DispatchQueue+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 24.04.2023.
//

import Foundation

public func ensureOnMain(_ block: @escaping () -> Void) {
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

public func ensureOnGlobal(_ block: @escaping () -> Void) {
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

public func ensureOnBackground(_ block: @escaping () -> Void) {
    if DispatchQueue.getSpecific(key: key) === backgroundQueueValue {
        block()
    } else {
        backgroundQueue.async(execute: block)
    }
}
