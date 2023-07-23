//
//  ASTableNode+Support.swift
//  VATextureKit
//
//  Created by VAndrJ on 23.07.2023.
//

import AsyncDisplayKit

extension ASTableNode {

    func reloadDataWithoutAnimations() {
        reloadData { [weak self] in
            DispatchQueue.main.async {
                self?.disableAllLayerAnimations()
            }
        }
    }
}
