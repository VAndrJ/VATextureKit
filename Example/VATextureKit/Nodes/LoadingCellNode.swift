//
//  LoadingCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 26.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class LoadingCellNode: VACellNode {
    private let loaderNode = _LoadingCellShimmerNode(data: .init())
    
    init(viewModel: LoadingCellNodeViewModel) {
        super.init()
        
        style.height = .points(viewModel.height)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        loaderNode
            .wrapped()
    }
}

class LoadingCellNodeViewModel: CellViewModel {
    let height: CGFloat

    internal init(height: CGFloat = 100) {
        self.height = height
    }
}

private class _LoadingCellShimmerNode: VAShimmerNode {
    let tileNode = VAShimmerTileNode(data: .init())

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        tileNode.wrapped()
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available (iOS 13.0, *)
struct LoadingCellNode_Preview: PreviewProvider {
    static var previews: some View {
        LoadingCellNode(viewModel: .init(height: 100))
            .sRepresentation(layout: .fixed(CGSize(same: 100)))
    }
}
#endif
