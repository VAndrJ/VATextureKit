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
