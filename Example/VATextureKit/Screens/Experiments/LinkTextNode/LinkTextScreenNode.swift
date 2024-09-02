//
//  LinkTextScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 03.05.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct LinkTextNavigationIdentity: DefaultNavigationIdentity {}

final class LinkTextScreenNode: ScreenNode, @unchecked Sendable {
    private lazy var linkTextNode = VALinkTextNode(text: [
        .loremText,
        "https://texturegroup.org",
        .loremText,
        "https://github.com/texturegroup/texture",
    ].joined(separator: " "))

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            linkTextNode
                .padding(.all(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }

    override func bind() {
        linkTextNode.onLinkTap = { UIApplication.shared.open($0) }
    }
}
