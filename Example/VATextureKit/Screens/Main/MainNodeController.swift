//
//  MainNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

/// ViewController as a View axample
final class MainNodeController: VANodeController {
    private(set) lazy var listNode = VATableListNode(data: .init(
        listDataObs: viewModel.listDataObs,
        onSelect: viewModel.didSelect(indexPath:),
        cellGetter: MainListCellNode.init(viewModel:),
        sectionHeaderGetter: MainListSectionHeaderNode.init(viewModel:)
    ))
    let descriptionNode = VATextNode(text: "Examples", fontStyle: .headline)
    
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
                    .centered(.X)
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
