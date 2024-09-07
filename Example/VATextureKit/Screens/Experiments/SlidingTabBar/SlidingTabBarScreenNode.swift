//
//  SlidingTabBarScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 01.05.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

struct SlidingTabBarNavigationIdentity: DefaultNavigationIdentity {}

final class SlidingTabBarScreenNode: ScreenNode, @unchecked Sendable {
    private lazy var pagerNode = VAMainActorWrapperNode {
        VAPagerNode(context: .init(
            items: (0...5).map { PagerCardCellNodeViewModel(title: "Title \($0)", description: "Description \($0)") },
            cellGetter: mapToCell(viewModel:)
        ))
    }
    private lazy var topTabBarNode = VASlidingTabBarNode(context: .init(
        data: (0...5).map { "Title".repeating($0) },
        spacing: 16,
        contentInset: .init(horizontal: 16),
        indicatorInset: 8,
        color: { $0.systemPurple },
        item: { data, onSelect in VASlidingTabTextNode(data: data, onSelect: onSelect) },
        indexObs: { [pagerNode] in pagerNode.child.indexObs },
        onSelect: { [weak pagerNode] in pagerNode?.child.scroll(to: $0) }
    ))
    private lazy var floatingTabBarNode = VASlidingTabBarNode(context: .init(
        data: (0...5).map { "Title".repeating($0) },
        spacing: 16,
        contentInset: .init(vertical: 8, horizontal: 16),
        indicatorInset: 8,
        color: { $0.systemBlue },
        item: { data, onSelect in VASlidingTabTextNode(data: data, onSelect: onSelect) },
        indexObs: { [pagerNode] in pagerNode.child.indexObs },
        onSelect: { [weak pagerNode] in pagerNode?.child.scroll(to: $0) }
    )).apply {
        $0.cornerCurve = .continuous
        $0.borderWidth = 1
    }
    private lazy var previousButtonNode = HapticButtonNode(title: "Previous")
        .minConstrained(size: .init(same: 44))
    private lazy var nextButtonNode = HapticButtonNode(title: "Next")
        .minConstrained(size: .init(same: 44))

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

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
        floatingTabBarNode.borderUIColor = theme.quaternaryLabel
    }

    override func bind() {
        previousButtonNode.onTap = self ?> { $0.pagerNode.child.previous() }
        nextButtonNode.onTap = self ?> { $0.pagerNode.child.next() }
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
