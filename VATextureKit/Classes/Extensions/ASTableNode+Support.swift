//
//  ASTableNode+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.07.2023.
//

import AsyncDisplayKit

public extension ASTableNode {

    func reloadDataWithoutAnimations() {
        reloadData { [weak self] in
            mainAsync { [weak self] in
                self?.disableAllLayerAnimations()
            }
        }
    }
}
