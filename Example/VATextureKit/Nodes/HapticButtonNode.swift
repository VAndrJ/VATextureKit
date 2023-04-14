//
//  HapticButtonNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 14.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class HapticButtonNode: VAButtonNode, VAHapticable {

    override func didLoad() {
        super.didLoad()

        bindTouchHaptic(style: .heavy)
    }
}
