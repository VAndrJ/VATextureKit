//
//  CollectionExampleCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class CollectionExampleCellNode: VACellNode {
    let imageNode = ASNetworkImageNode().apply {
        $0.contentMode = .scaleAspectFill
    }
    let titleNode: VATextNode
    
    let viewModel: CollectionExampleCellNodeViewModel
    
    init(viewModel: CollectionExampleCellNodeViewModel) {
        self.titleNode = VATextNode(
            text: viewModel.title,
            textStyle: .body,
            maximumNumberOfLines: 1
        )
        self.viewModel = viewModel
        
        super.init()
        
        guard let url = viewModel.image.flatMap(URL.init(string:)) else {
            return
        }
        imageNode.url = url
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column {
            imageNode
                .flex(shrink: 0.1, grow: 1)
            titleNode
                .padding(.all(4))
        }
    }
    
    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}

class CollectionExampleCellNodeViewModel: CellViewModel {
    let image: String?
    let title: String

    init(image: String? = nil, title: String) {
        self.image = image
        self.title = title
    }
}
