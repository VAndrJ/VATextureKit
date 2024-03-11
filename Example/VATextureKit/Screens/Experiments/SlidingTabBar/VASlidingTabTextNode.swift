//
//  VASlidingTabTextNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 03.05.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class VASlidingTabTextNode: DisplayNode, VASlidingTab {
    let titleNode: VATextNode
    let topTitleNode: VATextNode
    let buttonNode = VAButtonNode()

    private let maskLayer = CAShapeLayer()
    private let onSelect: () -> Void

    required init(data: String, onSelect: @escaping () -> Void) {
        self.onSelect = onSelect
        self.titleNode = VATextNode(text: data)
        self.topTitleNode = VATextNode(text: data, colorGetter: { $0.systemBackground })

        super.init()
    }

    override func didLoad() {
        super.didLoad()

        setupMask()
    }

    func update(intersection: CGRect) {
        maskLayer.path = UIBezierPath(rect: intersection).cgPath
    }

    private func setupMask() {
        maskLayer.path = UIBezierPath(rect: .zero).cgPath
        topTitleNode.layer.mask = maskLayer
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Stack {
            titleNode
            topTitleNode
        }
        .padding(.vertical(8))
        .overlay(buttonNode)
    }

    override func bind() {
        buttonNode.onTap = onSelect
    }
}
