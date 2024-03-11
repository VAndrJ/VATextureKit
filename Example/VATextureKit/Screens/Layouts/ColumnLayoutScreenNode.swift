//
//  ColumnLayoutScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct ColumnLayoutNavigationIdentity: DefaultNavigationIdentity {}

final class ColumnLayoutScreenNode: ScrollScreenNode {
    private lazy var mainCrossStartExampleNode = MainAxisColumnLayoutExampleNode(
        title: "Main axis .start\nCross axis .start",
        selection: ".start",
        main: .start
    )
    private lazy var mainEndExampleNode = MainAxisColumnLayoutExampleNode(
        title: "Main axis .end",
        selection: ".end",
        main: .end
    )
    private lazy var mainCenterExampleNode = MainAxisColumnLayoutExampleNode(
        title: "Main axis .center",
        selection: ".center",
        main: .center
    )
    private lazy var mainSpaceBetweenExampleNode = MainAxisColumnLayoutExampleNode(
        title: "Main axis .spaceBetween",
        selection: ".spaceBetween",
        main: .spaceBetween
    )
    private lazy var mainSpaceAroundExampleNode = MainAxisColumnLayoutExampleNode(
        title: "Main axis .spaceAround",
        selection: ".spaceAround",
        main: .spaceAround
    )
    private lazy var crossCenterExampleNode = CrossAxisColumnLayoutExampleNode(
        title: "Cross axis .center",
        selection: ".center",
        cross: .center
    )
    private lazy var crossEndExampleNode = CrossAxisColumnLayoutExampleNode(
        title: "Cross axis .end",
        selection: ".end",
        cross: .end
    )
    private lazy var crossStretchExampleNode = CrossAxisColumnLayoutExampleNode(
        title: "Cross axis .stretch",
        selection: ".stretch",
        cross: .stretch
    )

    init() {
        super.init(data: .init(contentInset: UIEdgeInsets(vertical: 24)))
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

private class MainAxisColumnLayoutExampleNode: DisplayNode {
    private lazy var exampleNodes = (1..<4).map { _ in ASDisplayNode().sized(CGSize(same: 24)) }
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

private class CrossAxisColumnLayoutExampleNode: DisplayNode {
    private lazy var exampleNodes = (1...4).map {
        if cross == .stretch {
            return ASDisplayNode().sized(height: 12 * CGFloat($0))
        } else {
            return ASDisplayNode().sized(CGSize(same: 8 * CGFloat($0)))
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
