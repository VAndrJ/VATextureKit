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
        items: (0...2).map { PagerCardCellNodeViewModel(title: "Title \($0)", description: "Description \($0)") },
        cellGetter: mapToCell(viewModel:),
        isCircular: true
    ))
    private lazy var previousButtonNode = VAButtonNode()
    private lazy var nextButtonNode = VAButtonNode()

    override func didLoad() {
        super.didLoad()

        bind()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea(edges: [.top, .horizontal]) {
            Column(cross: .stretch) {
                Row(main: .spaceBetween) {
                    previousButtonNode
                    nextButtonNode
                }
                .padding(.all(16))
                pagerNode
                    .flex(grow: 1)
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        backgroundColor = theme.systemBackground
        previousButtonNode.configure(title: "Previous", theme: theme)
        nextButtonNode.configure(title: "Next", theme: theme)
    }

    private func bind() {
        previousButtonNode.onTap = pagerNode.previous
        nextButtonNode.onTap = pagerNode.next
    }
}
