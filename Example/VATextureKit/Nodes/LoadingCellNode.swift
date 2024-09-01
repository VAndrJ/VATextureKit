//
//  LoadingCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 26.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

final class LoadingCellNode: VACellNode, @unchecked Sendable {
    private let shimmerNode = _LoadingCellShimmerNode(context: .init())
    
    init(viewModel: LoadingCellNodeViewModel) {
        super.init()
        
        style.height = .points(viewModel.height)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        shimmerNode
            .wrapped()
    }
}

final class LoadingCellNodeViewModel: CellViewModel {
    let height: CGFloat

    internal init(height: CGFloat = 100) {
        self.height = height
    }
}

private class _LoadingCellShimmerNode: VAShimmerNode, @unchecked Sendable {
    let tileNode = VAShimmerTileNode()

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        tileNode
            .wrapped()
    }
}

#if DEBUG && canImport(SwiftUI)
import SwiftUI

struct LoadingCellNode_Preview: PreviewProvider {
    static var previews: some View {
        LoadingCellNode(viewModel: .init(height: 100))
            .sRepresentation(layout: .fixed(CGSize(same: 100)))
    }
}
#endif
