//
//  ReadMoreTextControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 19.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit
import Swiftional

final class ReadMoreTextControllerNode: VASafeAreaDisplayNode {
    private lazy var readMoreTextNode = VAReadMoreTextNode(
        text: .loremText,
        maximumNumberOfLines: 2,
        readMore: .init(
            text: "Read more",
            fontStyle: .headline,
            colorGetter: { $0.systemBlue }
        )
    )

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                readMoreTextNode
            }
            .padding(.all(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        readMoreTextNode.backgroundColor = theme.systemYellow.withAlphaComponent(0.08)
    }
}
