//
//  MainNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

struct MainNavigationIdentity: DefaultNavigationIdentity {}

// MARK: - ViewController as a View axample

extension MainNodeController {

    convenience init(navigator: Navigator) {
        self.init(viewModel: .init(navigator: navigator as? AppNavigator))
    }
}

final class MainNodeController: VANodeController, @unchecked Sendable {
    private lazy var listNode = VATableListNode(data: .init(
        listDataObs: viewModel.listDataObs,
        onSelect: viewModel ?>> { $0.didSelect(indexPath:) },
        cellGetter: MainListCellNode.init(viewModel:),
        sectionHeaderGetter: MainListSectionHeaderNode.init(viewModel:)
    ))
    private lazy var descriptionNode = VATextNode(text: "Examples", fontStyle: .headline)
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }

    // A different approach to organization: we set the layout parameters that are enough to set once
    // in one place, near the `layoutSpecThatFits`.
    override func configureLayoutElements() {
        listNode
            .flex(shrink: 0.1, grow: 1)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                listNode
                descriptionNode
                    .centered(.X)
            }
        }
    }
    
    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)
        
        contentNode.backgroundColor = theme.systemBackground
        listNode.backgroundColor = theme.systemBackground
    }
    
    override func configure() {
        title = "Examples"
    }
}
