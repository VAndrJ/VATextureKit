//
//  MainListCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

class MainListCellNode: VACellNode {
    private let titleNode: VATextNode
    private let descriptionNode: VATextNode
    
    init(title: String, description: String) {
        self.titleNode = VATextNode(text: title)
        self.descriptionNode = VATextNode(
            text: description,
            textStyle: .footnote,
            themeColor: { $0.secondaryLabel }
        )
        
        super.init()
        
        accessoryType = .disclosureIndicator
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 4, cross: .stretch) {
            titleNode
            descriptionNode
        }
        .padding(.all(16))
    }
}
