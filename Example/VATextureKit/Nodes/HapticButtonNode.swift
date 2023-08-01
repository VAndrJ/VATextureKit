//
//  HapticButtonNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 14.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class HapticButtonNode: VAButtonNode, VAHapticable {
    private let titleTextNode: VATextNode

    override var isHighlighted: Bool {
        didSet { updateTitle() }
    }
    override var isEnabled: Bool {
        didSet { updateTitle() }
    }

    init(title: String) {
        self.titleTextNode = VATextNode(string: title, color: { $0.systemBlue })

        super.init()
    }

    override func didLoad() {
        super.didLoad()

        bindTouchHaptic(style: .heavy)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .centered()
    }

    private func updateTitle() {
        switch (isEnabled, isHighlighted) {
        case (true, true):
            titleTextNode.alpha = 0.4
        case (true, false):
            titleTextNode.alpha = 1
        case (false, _):
            titleTextNode.alpha = 0.2
        }
    }
}
