//
//  ASTableNode+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.07.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

public extension ASTableNode {

    func reloadDataWithoutAnimations() {
        reloadData { [weak self] in
            mainAsync { [weak self] in
                self?.disableAllLayerAnimations()
            }
        }
    }
}
