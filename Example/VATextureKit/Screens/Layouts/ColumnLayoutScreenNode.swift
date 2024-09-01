//
//  ColumnLayoutScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct ColumnLayoutNavigationIdentity: DefaultNavigationIdentity {}

final class ColumnLayoutScreenNode: ScrollScreenNode, @unchecked Sendable {
    private lazy var mainCrossStartExampleNode = _MainAxisColumnLayoutExampleNode(
        title: "Main axis .start\nCross axis .start",
        selection: ".start",
        main: .start
    )
    private lazy var mainEndExampleNode = _MainAxisColumnLayoutExampleNode(
        title: "Main axis .end",
        selection: ".end",
        main: .end
    )
    private lazy var mainCenterExampleNode = _MainAxisColumnLayoutExampleNode(
        title: "Main axis .center",
        selection: ".center",
        main: .center
    )
    private lazy var mainSpaceBetweenExampleNode = _MainAxisColumnLayoutExampleNode(
        title: "Main axis .spaceBetween",
        selection: ".spaceBetween",
        main: .spaceBetween
    )
    private lazy var mainSpaceAroundExampleNode = _MainAxisColumnLayoutExampleNode(
        title: "Main axis .spaceAround",
        selection: ".spaceAround",
        main: .spaceAround
    )
    private lazy var crossCenterExampleNode = _CrossAxisColumnLayoutExampleNode(
        title: "Cross axis .center",
        selection: ".center",
        cross: .center
    )
    private lazy var crossEndExampleNode = _CrossAxisColumnLayoutExampleNode(
        title: "Cross axis .end",
        selection: ".end",
        cross: .end
    )
    private lazy var crossStretchExampleNode = _CrossAxisColumnLayoutExampleNode(
        title: "Cross axis .stretch",
        selection: ".stretch",
        cross: .stretch
    )

    init() {
        super.init(context: .init(contentInset: UIEdgeInsets(vertical: 24)))
    }

    override func scrollLayoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 32, cross: .stretch) {
            mainCrossStartExampleNode
            mainEndExampleNode
            mainCenterExampleNode
            mainSpaceBetweenExampleNode
            mainSpaceAroundExampleNode
            crossCenterExampleNode
            crossEndExampleNode
            crossStretchExampleNode
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.secondarySystemBackground
    }
}

private class _MainAxisColumnLayoutExampleNode: DisplayNode, @unchecked Sendable {
    private lazy var exampleNodes = (1..<4).map { _ in ASDisplayNode().sized(.init(same: 24)) }
    private lazy var comparisonNode = ASDisplayNode().sized(CGSize(width: 24, height: 200))
    private let titleTextNode: VATextNode
    private let main: ASStackLayoutJustifyContent

    init(title: String, selection: String, main: ASStackLayoutJustifyContent) {
        self.titleTextNode = getTitleTextNode(string: title, selection: selection)
        self.main = main

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 16, cross: .stretch) {
            titleTextNode
                .padding(.horizontal(16))
            Row(spacing: 16, cross: .stretch) {
                comparisonNode
                Column(spacing: 8, main: main) {
                    exampleNodes
                }
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        exampleNodes.forEach { $0.backgroundColor = theme.systemGray }
        comparisonNode.backgroundColor = theme.systemGray6
    }
}

private class _CrossAxisColumnLayoutExampleNode: DisplayNode, @unchecked Sendable {
    private lazy var exampleNodes = (1...4).map {
        if cross == .stretch {
            ASDisplayNode()
                .sized(height: 12 * CGFloat($0))
        } else {
            ASDisplayNode()
                .sized(.init(same: 8 * CGFloat($0)))
        }
    }
    private let titleTextNode: VATextNode
    private let cross: ASStackLayoutAlignItems

    init(title: String, selection: String, cross: ASStackLayoutAlignItems) {
        self.titleTextNode = getTitleTextNode(string: title, selection: selection)
        self.cross = cross

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 16, cross: .stretch) {
            titleTextNode
                .padding(.horizontal(16))
            Column(spacing: 8, cross: cross) {
                exampleNodes
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        exampleNodes.forEach { $0.backgroundColor = theme.systemGray }
    }
}
