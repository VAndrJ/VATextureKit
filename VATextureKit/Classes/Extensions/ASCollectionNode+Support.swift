//
//  ASCollectionNode+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//

import AsyncDisplayKit

public extension ASCollectionNode {
    var isHorizontal: Bool { scrollableDirections == .horizontal }

    func reloadDataWithoutAnimations() {
        reloadData { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.disableAllLayerAnimations()
            }
        }
    }
}
