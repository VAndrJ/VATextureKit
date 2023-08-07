//
//  ElementsScrollingAnimationListViewController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 30.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

// MARK: - ViewController as a View example

final class ElementsScrollingAnimationListViewController: VANodeController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    private(set) lazy var listNode = VAListNode(
        data: .init(
            listDataObs: .just((0...100).map { _ in
                ImageCellNodeViewModel(
                    image: testImages.randomElement(),
                    ratio: Double.random(in: 0.3...0.5),
                    cornerRadius: 8,
                    onScroll: .scale
                )
            }),
            cellGetter: mapToCell(viewModel:)
        ),
        layoutData: .init(
            contentInset: UIEdgeInsets(horizontal: 16),
            layout: .default(parameters: .init(
                minimumLineSpacing: 16
            ))
        )
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        listNode.view.alwaysBounceVertical = true
    }

    override func layoutSpec(_ node: ASDisplayNode, _ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            listNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        contentNode.backgroundColor = theme.systemBackground
        listNode.backgroundColor = theme.systemBackground
    }
}

private func mapToCell(viewModel: CellViewModel) -> ASCellNode {
    switch viewModel {
    case let viewModel as ImageCellNodeViewModel:
        return ImageCellNode(viewModel: viewModel)
    default:
        assertionFailure("Implement")
        return ASCellNode()
    }
}
