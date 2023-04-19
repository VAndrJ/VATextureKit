//
//  CompositingCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 05.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class CompositingCellNode: VACellNode {
    let titleTextNode: VATextNode

    init(viewModel: CompositingCellNodeViewModel) {
        self.titleTextNode = VATextNode(
            text: viewModel.compositingFilter.flatMap { "\($0)" } ?? viewModel.blendMode.flatMap { "\($0)" } ?? "",
            fontStyle: .body
        )

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .padding(.all(16))
            .centered()
    }
}

class CompositingCellNodeViewModel: CellViewModel {
    let compositingFilter: ASDisplayNode.CompositingFilter?
    let blendMode: ASDisplayNode.BlendMode?

    init(compositingFilter: ASDisplayNode.CompositingFilter? = nil, blendMode: ASDisplayNode.BlendMode? = nil) {
        assert(compositingFilter != nil || blendMode != nil)
        self.compositingFilter = compositingFilter
        self.blendMode = blendMode
    }
}
