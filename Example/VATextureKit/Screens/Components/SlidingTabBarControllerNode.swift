//
//  SlidingTabBarControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 01.05.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class SlidingTabBarControllerNode: VASafeAreaDisplayNode {
    private lazy var pagerNode = VAPagerNode(data: .init(
        items: (0...5).map { PagerCardCellNodeViewModel(title: "Title \($0)", description: "Description \($0)") },
        cellGetter: mapToCell(viewModel:)
    ))
    private lazy var topTabBarNode = VASlidingTabBarNode(data: .init(
        data: (0...5).map { "Title".repeating($0) },
        spacing: 16,
        contentInset: UIEdgeInsets(horizontal: 16),
        indicatorInset: 8,
        color: { $0.systemPurple },
        item: { data, onSelect in VASlidingTabTextNode(data: data, onSelect: onSelect) },
        indexObs: pagerNode.indexObs,
        onSelect: pagerNode ?> { $0.scroll(to: $1) }
    ))
    private lazy var floatingTabBarNode = VASlidingTabBarNode(data: .init(
        data: (0...5).map { "Title".repeating($0) },
        spacing: 16,
        contentInset: UIEdgeInsets(vertical: 8, horizontal: 16),
        indicatorInset: 8,
        color: { $0.systemBlue },
        item: { data, onSelect in VASlidingTabTextNode(data: data, onSelect: onSelect) },
        indexObs: pagerNode.indexObs,
        onSelect: pagerNode ?> { $0.scroll(to: $1) }
    ))

    private let bag = DisposeBag()

    override func didLoad() {
        super.didLoad()

        floatingTabBarNode.layer.cornerCurve = .continuous
        floatingTabBarNode.borderWidth = 1
    }

    override func layout() {
        super.layout()

        floatingTabBarNode.cornerRadius = floatingTabBarNode.frame.height / 2
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column {
                topTabBarNode
                    .wrapped()
                Stack {
                    pagerNode
                    Column {
                        floatingTabBarNode
                            .wrapped()
                    }
                    .padding(.horizontal(16), .bottom(48))
                    .relatively(horizontal: .start, vertical: .end, sizing: .minimumHeight)
                }
                .flex(grow: 1)
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        floatingTabBarNode.backgroundColor = theme.systemBackground
        floatingTabBarNode.borderColor = theme.quaternaryLabel.cgColor
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
