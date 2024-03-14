//
//  ContentSizeNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct ContentSizeNavigationIdentity: DefaultNavigationIdentity {}

final class ContentSizeNodeController: VANodeController {
    let contentSizeTextNode = VATextNode(fontStyle: .title3, alignment: .center)

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                contentSizeTextNode
                    .padding(.all(16))
            }
        }
    }

    override func configure() {
        title = "Content size"
        updateContentSizeLabel()
    }

    override func configureContentSize(_ contentSize: UIContentSizeCategory) {
        updateContentSizeLabel()
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        contentNode.backgroundColor = theme.systemBackground
    }
    
    private func updateContentSizeLabel() {
        contentSizeTextNode.text = appContext.contentSizeManager.contentSize.rawValue
    }
}
