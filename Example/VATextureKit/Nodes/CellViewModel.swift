//
//  CellViewModel.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 25.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx
import Differentiator

class CellViewModel: Equatable, IdentifiableType {
    static func == (lhs: CellViewModel, rhs: CellViewModel) -> Bool {
        lhs.identity == rhs.identity
    }
    
    let identity = UUID().uuidString
}
