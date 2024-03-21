//
//  SlidingTabBarScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 01.05.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

struct SlidingTabBarNavigationIdentity: DefaultNavigationIdentity {}

final class SlidingTabBarScreenNode: ScreenNode {
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
        onSelect: pagerNode ?>> { $0.scroll(to:) }
    ))
    private lazy var floatingTabBarNode = VASlidingTabBarNode(data: .init(
        data: (0...5).map { "Title".repeating($0) },
        spacing: 16,
        contentInset: UIEdgeInsets(vertical: 8, horizontal: 16),
        indicatorInset: 8,
        color: { $0.systemBlue },
        item: { data, onSelect in VASlidingTabTextNode(data: data, onSelect: onSelect) },
        indexObs: pagerNode.indexObs,
        onSelect: pagerNode ?>> { $0.scroll(to:) }
    )).apply {
        $0.cornerCurve = .continuous
        $0.borderWidth = 1
    }
    private lazy var previousButtonNode = HapticButtonNode(title: "Previous")
        .minConstrained(size: CGSize(same: 44))
    private lazy var nextButtonNode = HapticButtonNode(title: "Next")
        .minConstrained(size: CGSize(same: 44))

    override func layout() {
        super.layout()

        floatingTabBarNode.cornerRadius = floatingTabBarNode.frame.height / 2
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                topTabBarNode
                    .wrapped()
                Row(main: .spaceBetween) {
                    previousButtonNode
                    nextButtonNode
                }
                .padding(.horizontal(16))
                Stack {
                    pagerNode
                    Column {
                        floatingTabBarNode
                            .wrapped()
                    }
                    .padding(.horizontal(16), .bottom(48))
                    .relatively(vertical: .end, sizing: .minimumHeight)
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

    override func bind() {
        previousButtonNode.onTap = self ?>> { $0.pagerNode.previous }
        nextButtonNode.onTap = self ?>> { $0.pagerNode.next }
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
