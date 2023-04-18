//
//  MainListCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class MainListCellNode: VACellNode {
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

#if canImport(SwiftUI)
import SwiftUI

@available (iOS 13.0, *)
struct MainListCellNode_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            ForEach(
                [
                    MainListCellNodeViewModel(title: "Title", description: "Description", route: .alert),
                    .init(title: "Title".dummyLong(), description: "Description".dummyLong(), route: .alert),
                    .init(title: "Title", description: "Description".dummyLong(), route: .alert),
                    .init(title: "Title".dummyLong(), description: "Description", route: .alert),
                ],
                id: \.identity
            ) {
                MainListCellNode(viewModel: $0)
                    .sRepresentation(layout: .flexibleHeight(width: 320))
                    .background(Color.white)
                    .padding(8)
            }
        }
        .background(Color.orange)
        .previewLayout(.sizeThatFits)
    }
}
#endif
