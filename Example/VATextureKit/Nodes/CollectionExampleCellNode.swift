//
//  CollectionExampleCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class CollectionExampleCellNode: VACellNode {
    let imageNode = VANetworkImageNode(contentMode: .scaleAspectFill)
    let titleNode: VATextNode
    
    let viewModel: CollectionExampleCellNodeViewModel
    
    init(viewModel: CollectionExampleCellNodeViewModel) {
        self.titleNode = VATextNode(
            text: viewModel.title,
            fontStyle: .body,
            maximumNumberOfLines: 1
        )
        self.viewModel = viewModel
        
        super.init()
        
        guard let url = viewModel.image.flatMap(URL.init(string:)) else { return }

        imageNode.url = url
    }

    override func configureLayoutElements() {
        imageNode
            .flex(shrink: 0.1, grow: 1)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column {
            imageNode
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

#if DEBUG && canImport(SwiftUI)
import SwiftUI

@available (iOS 13.0, *)
struct CollectionExampleCellNode_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            ForEach(
                [
                    CollectionExampleCellNodeViewModel(image: testImages.randomElement(), title: "Title"),
                    .init(image: testImages.randomElement(), title: "Title".dummyLong()),
                ],
                id: \.identity
            ) {
                CollectionExampleCellNode(viewModel: $0)
                    .sRepresentation(layout: .fixed(CGSize(same: 200)))
                    .padding(8)
            }
        }
        .background(Color.orange)
        .previewLayout(.sizeThatFits)
    }
}
#endif
