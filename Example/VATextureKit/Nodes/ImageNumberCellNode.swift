//
//  ImageNumberCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class ImageNumberCellNode: VACellNode, @unchecked Sendable {
    let imageNode: VANetworkImageNode
    let numberTextNode: VATextNode
    let tonerNode = ASDisplayNode()

    let viewModel: ImageNumberCellNodeViewModel
    
    init(viewModel: ImageNumberCellNodeViewModel) {
        self.viewModel = viewModel
        self.numberTextNode = VATextNode(
            text: "\(viewModel.number)",
            fontStyle: .largeTitle,
            colorGetter: { $0.systemPurple }
        )
        self.imageNode = VANetworkImageNode(
            image: viewModel.image,
            contentMode: .scaleAspectFill
        )
        
        super.init()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode
            .ratio(viewModel.ratio)
            .overlay(tonerNode)
            .overlay(numberTextNode.centered())
    }
    
    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        tonerNode.backgroundColor = theme.label.withAlphaComponent(0.32)
    }
}

final class ImageNumberCellNodeViewModel: CellViewModel {
    let image: String?
    let ratio: CGFloat
    let number: Int

    init(image: String? = nil, ratio: CGFloat = 1, number: Int) {
        self.image = image
        self.ratio = ratio
        self.number = number
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI

struct ImageNumberCellNode_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            ForEach(
                [
                    ImageNumberCellNodeViewModel(image: testImages.randomElement(), ratio: 1, number: 1),
                    .init(image: testImages.randomElement(), ratio: 1 / 2, number: 1),
                    .init(image: testImages.randomElement(), ratio: 2, number: 1),
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
