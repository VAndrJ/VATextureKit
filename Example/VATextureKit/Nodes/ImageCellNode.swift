//
//  ImageCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class ImageCellNode: VACellNode {
    let imageNode = ASNetworkImageNode().apply {
        $0.contentMode = .scaleAspectFill
    }
    
    let viewModel: ImageCellNodeViewModel
    
    init(viewModel: ImageCellNodeViewModel) {
        self.viewModel = viewModel
        
        super.init()
        
        guard let url = viewModel.image.flatMap(URL.init(string:)) else {
            return
        }
        imageNode.url = url
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode
            .ratio(viewModel.ratio)
    }
    
    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}

class ImageCellNodeViewModel: CellViewModel {
    let image: String?
    let ratio: CGFloat

    init(image: String? = nil, ratio: CGFloat = 1) {
        self.image = image
        self.ratio = ratio
    }
}
