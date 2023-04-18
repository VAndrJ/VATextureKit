//
//  VAButtonNode+Support.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

extension VAButtonNode {

    func configure(title: String, theme: VATheme) {
        [(theme.systemBlue, UIControl.State.normal), (theme.systemBlue.withAlphaComponent(0.4), .highlighted)].forEach {
            setTitle(title, with: nil, with: $0, for: $1)
        }
    }
}
