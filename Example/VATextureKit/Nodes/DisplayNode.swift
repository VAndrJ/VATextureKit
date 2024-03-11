//
//  DisplayNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 11.03.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

class DisplayNode: VADisplayNode {

    override func didLoad() {
        super.didLoad()

        configure()
        bind()
    }

    @MainActor
    func bind() {}

    @MainActor
    func configure() {}
}
