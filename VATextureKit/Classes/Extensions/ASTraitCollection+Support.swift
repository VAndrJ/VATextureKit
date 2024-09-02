//
//  ASTraitCollection+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

public extension ASTraitCollection {
    @inline(__always) @inlinable var ui: UITraitCollection {
        ASPrimitiveTraitCollectionToUITraitCollection(primitiveTraitCollection())
    }
}
