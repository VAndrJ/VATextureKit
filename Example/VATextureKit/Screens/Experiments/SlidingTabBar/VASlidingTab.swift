//
//  VASlidingTab.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 03.05.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import Foundation

protocol VASlidingTab {
    associatedtype TabData

    init(data: TabData, onSelect: @escaping () -> Void)

    func update(intersection: CGRect)
}
