//
//  ASTraitCollection+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//

public import AsyncDisplayKit

public extension ASTraitCollection {
    @inline(__always) @inlinable var ui: UITraitCollection {
        ASPrimitiveTraitCollectionToUITraitCollection(primitiveTraitCollection())
    }
}
