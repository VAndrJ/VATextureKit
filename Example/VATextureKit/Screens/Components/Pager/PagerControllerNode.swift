//
//  PagerControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

final class PagerControllerNode: VASafeAreaDisplayNode {
    private lazy var pagerNode = VAPagerNode(data: .init(
        itemsObs: viewModel.pagerItemsObs,
        cellGetter: mapToCell(viewModel:),
        isCircular: true
    ))
    private lazy var previousButtonNode = HapticButtonNode(title: "Previous")
        .minConstrained(size: CGSize(same: 44))
    private lazy var nextButtonNode = HapticButtonNode(title: "Next")
        .minConstrained(size: CGSize(same: 44))
    private lazy var randomizeButtonNode = HapticButtonNode(title: "Randomize")
        .minConstrained(size: CGSize(same: 44))
    private lazy var pagerIndicatorNode = PagerIndicatorNode(pagerNode: pagerNode)
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
                        .relatively(horizontal: .center, vertical: .end)
                }
                .flex(grow: 1)
                randomizeButtonNode
                    .centered(.X)
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        backgroundColor = theme.systemBackground
    }

    private func bind() {
        previousButtonNode.onTap = self ?>> { $0.pagerNode.previous }
        nextButtonNode.onTap = self ?>> { $0.pagerNode.next }
        randomizeButtonNode.onTap = self ?>> { $0.viewModel.generateRandomPagerItems }
    }
}

private func mapToCell(viewModel: CellViewModel) -> ASCellNode {
    switch viewModel {
    case let viewModel as PagerCardCellNodeViewModel:
        return PagerCardCellNode(viewModel: viewModel)
    default:
        assertionFailure("Implement \(type(of: viewModel))")
        return ASCellNode()
    }
}
