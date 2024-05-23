//
//  Collection+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 15.03.2024.
//

import Foundation

public extension Collection {
    @inline(__always) @inlinable var isNotEmpty: Bool { !isEmpty }
}

public extension Optional where Wrapped: Collection {
    var isEmpty: Bool { self?.isEmpty ?? true }
    @inline(__always) @inlinable var isNotEmpty: Bool { !isEmpty }
}
