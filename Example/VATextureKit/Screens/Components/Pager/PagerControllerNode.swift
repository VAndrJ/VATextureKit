//
//  PagerControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

@MainActor
private func mapToCell(viewModel: CellViewModel) -> ASCellNode {
    switch viewModel {
    case let viewModel as PagerCardCellNodeViewModel:
        return PagerCardCellNode(viewModel: viewModel)
    default:
        assertionFailure("Implement \(type(of: viewModel))")
        return ASCellNode()
    }
}

final class PagerControllerNode: VASafeAreaDisplayNode {
    private lazy var pagerNode = VAPagerNode(data: .init(
        itemsObs: viewModel.pagerItemsObs,
        cellGetter: mapToCell(viewModel:),
        isCircular: true
    ))
    private lazy var previousButtonNode = VAButtonNode()
        .minConstrained(size: CGSize(same: 44))
    private lazy var nextButtonNode = VAButtonNode()
        .minConstrained(size: CGSize(same: 44))
    private lazy var randomizeButtonNode = VAButtonNode()
        .minConstrained(size: CGSize(same: 44))
    private lazy var pagerIndicatorNode = PagerIndicatorNode(
        pagerNode: pagerNode,
        itemsCountObs: viewModel.pagerItemsObs.map(\.count)
    )
    private let viewModel: PagerControllerNodeViewModel

    init(viewModel: PagerControllerNodeViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    override func didLoad() {
        super.didLoad()

        bind()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                Row(main: .spaceBetween) {
                    previousButtonNode
                    nextButtonNode
                }
                .padding(.horizontal(16))
                Stack {
                    pagerNode
                    pagerIndicatorNode
                        .relatively(horizontal: .start, vertical: .end)
                }
                .flex(grow: 1)
                randomizeButtonNode
                    .centered(centering: .X)
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        backgroundColor = theme.systemBackground
        previousButtonNode.configure(title: "Previous", theme: theme)
        nextButtonNode.configure(title: "Next", theme: theme)
        randomizeButtonNode.configure(title: "Randomize", theme: theme)
    }

    private func bind() {
        previousButtonNode.onTap = pagerNode.previous
        nextButtonNode.onTap = pagerNode.next
        randomizeButtonNode.onTap = viewModel.generateRandomPagerItems
    }
}
