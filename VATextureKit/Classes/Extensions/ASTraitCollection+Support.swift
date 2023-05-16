//
//  ASTraitCollection+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//

import AsyncDisplayKit

public extension ASTraitCollection {
    var ui: UITraitCollection { ASPrimitiveTraitCollectionToUITraitCollection(primitiveTraitCollection()) }
}
