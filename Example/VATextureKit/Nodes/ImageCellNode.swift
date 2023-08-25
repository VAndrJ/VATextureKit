//
//  ImageCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class ImageCellNode: VAScrollRespondingEdgeCellNode {
    let imageNode: VANetworkImageNode
    let viewModel: ImageCellNodeViewModel
    
    init(viewModel: ImageCellNodeViewModel) {
        self.viewModel = viewModel
        self.imageNode = VANetworkImageNode(
            image: viewModel.image,
            contentMode: .scaleAspectFill
        )
        
        super.init(onScroll: viewModel.onScroll)

        if let cornerRadius = viewModel.cornerRadius {
            self.cornerRadius = cornerRadius
        }
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
    let cornerRadius: CGFloat?
    let onScroll: VAEdgeCellChangeOnScroll

    init(
        image: String? = nil,
        ratio: CGFloat = 1,
        cornerRadius: CGFloat? = nil,
        onScroll: VAEdgeCellChangeOnScroll = .none
    ) {
        self.image = image
        self.ratio = ratio
        self.cornerRadius = cornerRadius
        self.onScroll = onScroll
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available (iOS 13.0, *)
struct ImageCellNode_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            ForEach(
                [
                    ImageCellNodeViewModel(image: testImages.randomElement(), ratio: 1),
                    .init(image: testImages.randomElement(), ratio: 1 / 2),
                    .init(image: testImages.randomElement(), ratio: 2),
                ],
                id: \.identity
            ) {
                ImageCellNode(viewModel: $0)
                    .sRepresentation(layout: .flexibleHeight(width: 100))
                    .padding(8)
            }
        }
        .background(Color.orange)
        .previewLayout(.sizeThatFits)
    }
}
#endif
