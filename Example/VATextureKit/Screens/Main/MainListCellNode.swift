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
    
    init(viewModel: MainListCellNodeViewModel) {
        self.titleNode = VATextNode(text: viewModel.title)
        self.descriptionNode = VATextNode(
            text: viewModel.description,
            textStyle: .footnote,
            themeColor: { $0.secondaryLabel }
        )
        
        super.init()
        
        accessoryType = .disclosureIndicator
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 4, cross: .stretch) {
            titleNode
                .flex(shrink: 0.1)
            descriptionNode
                .flex(shrink: 0.1)
        }
        .padding(.all(16))
    }
}

class MainListCellNodeViewModel: CellViewModel {
    let title: String
    let description: String
    let route: NavigationRoute

    init(title: String, description: String, route: NavigationRoute) {
        self.title = title
        self.description = description
        self.route = route
    }
}