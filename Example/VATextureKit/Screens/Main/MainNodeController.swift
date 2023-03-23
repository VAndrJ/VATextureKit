//
//  MainNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit
import SwiftUI

/// ViewController as a View axample
class MainNodeController: VANodeController {
    private(set) lazy var listNode = VATableListNode(data: .init(
        listData: viewModel.listData,
        onSelect: { [viewModel] in viewModel.didSelect(at: $0.row) },
        cellGetter: MainListCellNode.init(viewModel:)
    ))
    let descriptionNode = VATextNode(text: "Examples", textStyle: .headline)
    
    let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func layoutSpec(_ node: ASDisplayNode, _ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                listNode
                    .flex(shrink: 0.1, grow: 1)
                descriptionNode
                    .centered(centering: .X)
            }
        }
    }
    
    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)
        
        contentNode.backgroundColor = theme.systemBackground
    }
    
    private func configure() {
        title = "Examples"
    }
}
