//
//  ImageNumberCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class ImageNumberCellNode: VACellNode {
    let imageNode = ASNetworkImageNode().apply {
        $0.contentMode = .scaleAspectFill
    }
    let numberTextNode: VATextNode
    let tonerNode = ASDisplayNode().apply {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    let viewModel: ImageNumberCellNodeViewModel
    
    init(viewModel: ImageNumberCellNodeViewModel) {
        self.viewModel = viewModel
        self.numberTextNode = VATextNode(
            text: "\(viewModel.number)",
            textStyle: .largeTitle,
            colorGetter: { .white }
        )
        
        super.init()
        
        guard let url = viewModel.image.flatMap(URL.init(string:)) else {
            return
        }
        imageNode.url = url
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode
            .ratio(viewModel.ratio)
            .overlay(tonerNode)
            .overlay(numberTextNode.centered())
    }
    
    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}

class ImageNumberCellNodeViewModel: CellViewModel {
    let image: String?
    let ratio: CGFloat
    let number: Int

    init(image: String? = nil, ratio: CGFloat = 1, number: Int) {
        self.image = image
        self.ratio = ratio
        self.number = number
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available (iOS 13.0, *)
struct ImageNumberCellNode_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            ForEach(
                [
                    ImageNumberCellNodeViewModel(image: testImages.randomElement(), ratio: 1, number: 1),
                    ImageNumberCellNodeViewModel(image: testImages.randomElement(), ratio: 1 / 2, number: 1),
                    ImageNumberCellNodeViewModel(image: testImages.randomElement(), ratio: 2, number: 1),
                ],
                id: \.identity
            ) {
                ImageNumberCellNode(viewModel: $0)
                    .sRepresentation(layout: .flexibleHeight(width: 100))
                    .padding(8)
            }
        }
        .background(Color.orange)
        .previewLayout(.sizeThatFits)
    }
}
#endif
