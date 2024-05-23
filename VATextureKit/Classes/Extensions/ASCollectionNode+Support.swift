//
//  ASCollectionNode+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//

import AsyncDisplayKit

public extension ASCollectionNode {
    @inline(__always) @inlinable var isHorizontal: Bool { scrollableDirections == .horizontal }

    func reloadDataWithoutAnimations() {
        reloadData { [weak self] in
            mainAsync { [weak self] in
                self?.disableAllLayerAnimations()
            }
        }
    }
}
