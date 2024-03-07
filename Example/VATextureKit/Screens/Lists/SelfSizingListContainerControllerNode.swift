//
//  SelfSizingListContainerControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.11.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKitRx

struct SelfSizingListNavigationIdentity: DefaultNavigationIdentity {}

final class SelfSizingListContainerControllerNode: VASafeAreaDisplayNode {
    private lazy var listNode = VAListNode(
        data: .init(
            listDataObs: .just((0...1).map { index in
                ExampleCardCellNodeViewModel(title: "\(index)")
            }),
            cellGetter: ExampleCardCellNode.init(viewModel:)
        ),
        layoutData: .init(layout: .default(parameters: .init()))
    )
    private lazy var listNode1 = VAListNode(
        data: .init(
            listDataObs: .just((0...1).map { index in
                ExampleCardCellNodeViewModel(title: "\(index)")
            }),
            cellGetter: ExampleCardCellNode.init(viewModel:)
        ),
        layoutData: .init(layout: .default(parameters: .init()))
    )
    private let verticalTextNode = VATextNode(
        string: "Vertical",
        color: { $0.darkText }
    )
    private lazy var selfSizingListNode = VASelfSizingListContainerNode(
        child: listNode,
        direction: .vertical
    )
    private lazy var selfSizingListNode1 = VASelfSizingListContainerNode(
        child: listNode1,
        direction: .vertical,
        corner: .init(radius: .fixed(16), clipsToBounds: true)
    )

    private lazy var horizontalListNode = VAListNode(
        data: .init(
            listDataObs: .just((0...1).map { index in
                ExampleCardCellNodeViewModel(title: "\(index)")
            }),
            cellGetter: ExampleCardCellNode.init(viewModel:)
        ),
        layoutData: .init(layout: .default(parameters: .init(scrollDirection: .horizontal)))
    )
    private lazy var horizontalListNode1 = VAListNode(
        data: .init(
            listDataObs: .just((0...1).map { index in
                ExampleCardCellNodeViewModel(title: "\(index)")
            }),
            cellGetter: ExampleCardCellNode.init(viewModel:)
        ),
        layoutData: .init(layout: .default(parameters: .init(scrollDirection: .horizontal)))
    )
    private let horizontalTextNode = VATextNode(
        string: "Horizontal",
        color: { $0.darkText }
    )
    private lazy var horizontalSelfSizingListNode = VASelfSizingListContainerNode(
        child: horizontalListNode,
        direction: .horizontal
    )
    private lazy var horizontalSelfSizingListNode1 = VASelfSizingListContainerNode(
        child: horizontalListNode1,
        direction: .horizontal,
        corner: .init(radius: .fixed(16), clipsToBounds: true)
    )

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                verticalTextNode
                    .padding(.all(8))
                selfSizingListNode
                    .padding(.all(8))
                selfSizingListNode1
                    .padding(.all(8))

                horizontalTextNode
                    .padding(.all(8))
                Row {
                    horizontalSelfSizingListNode
                        .minConstrained(height: 72)
                        .padding(.all(8))
                    horizontalSelfSizingListNode1
                        .minConstrained(height: 64)
                        .padding(.all(8))
                }
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        listNode.backgroundColor = theme.systemBackground
    }
}

private class ExampleCardCellNode: VACellNode {
    let titleTextNode: VATextNode

    private let viewModel: ExampleCardCellNodeViewModel

    init(viewModel: ExampleCardCellNodeViewModel) {
        self.viewModel = viewModel
        self.titleTextNode = VATextNode(text: viewModel.title, fontStyle: .largeTitle)

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        titleTextNode
            .padding(.all(8))
            .centered()
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.label.withAlphaComponent(0.12)
    }
}

private class ExampleCardCellNodeViewModel: CellViewModel {
    let title: String

    init(title: String) {
        self.title = title
    }
}
