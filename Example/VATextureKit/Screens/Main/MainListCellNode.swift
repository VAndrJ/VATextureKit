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
    private lazy var chevronImageNode = VAImageNode(
        image: .init(resource: .chevronRight),
        size: .init(same: 14),
        contentMode: .center,
        tintColor: { $0.tertiaryLabel }
    )
    
    init(viewModel: MainListCellNodeViewModel) {
        self.titleNode = .init(text: viewModel.title)
        self.descriptionNode = .init(
            text: viewModel.description,
            fontStyle: .footnote,
            colorGetter: { $0.secondaryLabel }
        )
        
        super.init()

        if let titleTransitionAnimationId = viewModel.titleTransitionAnimationId {
            titleNode.transitionAnimationId = titleTransitionAnimationId
        }
        if let descriptionTransitionAnimationId = viewModel.descriptionTransitionAnimationId {
            descriptionNode.transitionAnimationId = descriptionTransitionAnimationId
        }
    }

    // A different approach to organization: we set the layout parameters that are enough to set once
    // in one place, near the `layoutSpecThatFits`.
    override func configureLayoutElements() {
        titleNode.flex(shrink: 0.1)
        descriptionNode.flex(shrink: 0.1)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Row(spacing: 4, main: .spaceBetween, cross: .center) {
            Column(spacing: 4) {
                titleNode
                descriptionNode
            }
            .flex(shrink: 0.1)
            chevronImageNode
        }
        .padding(.vertical(16), .left(16), .right(8))
    }
}

final class MainListCellNodeViewModel: CellViewModel {
    let title: String
    let description: String
    let destination: NavigationIdentity
    let titleTransitionAnimationId: String?
    let descriptionTransitionAnimationId: String?

    init(
        title: String,
        description: String,
        destination: NavigationIdentity
    ) {
        self.title = title
        self.description = description
        self.destination = destination
        self.titleTransitionAnimationId = nil
        self.descriptionTransitionAnimationId = nil
    }

    init(
        title: String,
        description: String,
        destination: NavigationIdentity,
        titleTransitionAnimationId: String,
        descriptionTransitionAnimationId: String
    ) {
        self.title = title
        self.description = description
        self.destination = destination
        self.titleTransitionAnimationId = titleTransitionAnimationId
        self.descriptionTransitionAnimationId = descriptionTransitionAnimationId
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI

struct MainListCellNode_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            ForEach(
                [
                    MainListCellNodeViewModel(title: "Title", description: "Description", destination: AlertNavigationIdentity()),
                    .init(title: "Title".dummyLong(), description: "Description".dummyLong(), destination: AlertNavigationIdentity()),
                    .init(title: "Title", description: "Description".dummyLong(), destination: AlertNavigationIdentity()),
                    .init(title: "Title".dummyLong(), description: "Description", destination: AlertNavigationIdentity()),
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
