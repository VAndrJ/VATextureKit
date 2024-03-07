//
//  RowLayoutControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct RowLayoutNavigationIdentity: DefaultNavigationIdentity {}

final class RowLayoutControllerNode: VASafeAreaDisplayNode {
    private lazy var mainCrossStartExampleNode = MainAxisRowLayoutExampleNode(
        title: "Cross axis .start\nMain axis .start",
        selection: ".start",
        main: .start
    )
    private lazy var mainEndExampleNode = MainAxisRowLayoutExampleNode(
        title: "Main axis .end",
        selection: ".end",
        main: .end
    )
    private lazy var mainCenterExampleNode = MainAxisRowLayoutExampleNode(
        title: "Main axis .center",
        selection: ".center",
        main: .center
    )
    private lazy var mainSpaceBetweenExampleNode = MainAxisRowLayoutExampleNode(
        title: "Main axis .spaceBetween",
        selection: ".spaceBetween",
        main: .spaceBetween
    )
    private lazy var mainSpaceAroundExampleNode = MainAxisRowLayoutExampleNode(
        title: "Main axis .spaceAround",
        selection: ".spaceAround",
        main: .spaceAround
    )
    private lazy var crossCenterExampleNode = CrossAxisRowLayoutExampleNode(
        title: "Cross axis .center",
        selection: ".center",
        cross: .center
    )
    private lazy var crossEndExampleNode = CrossAxisRowLayoutExampleNode(
        title: "Cross axis .end",
        selection: ".end",
        cross: .end
    )
    private lazy var crossStretchExampleNode = CrossAxisRowLayoutExampleNode(
        title: "Cross axis .stretch",
        selection: ".stretch",
        cross: .stretch
    )
    private lazy var scrollNode = VAScrollNode(data: .init(contentInset: UIEdgeInsets(vertical: 24)))

    init() {
        super.init()

        scrollNode.layoutSpecBlock = { [weak self] in
            self?.scrollLayoutSpecThatFits(constrainedSize: $1) ?? ASLayoutSpec()
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            scrollNode
        }
    }

    func scrollLayoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
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

private class MainAxisRowLayoutExampleNode: VADisplayNode {
    private lazy var exampleNodes = (0..<4).map { _ in ASDisplayNode().sized(CGSize(same: 48)) }
    private let titleTextNode: VATextNode
    private let main: ASStackLayoutJustifyContent

    init(title: String, selection: String, main: ASStackLayoutJustifyContent) {
        self.main = main
        self.titleTextNode = getTitleTextNode(string: title, selection: selection)

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 8, cross: .stretch) {
            titleTextNode
                .padding(.horizontal(16))
            Row(spacing: 8, main: main) {
                exampleNodes
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        exampleNodes.forEach {
            $0.backgroundColor = theme.systemGray
        }
    }
}

private class CrossAxisRowLayoutExampleNode: VADisplayNode {
    private lazy var exampleNodes = (1...4).map {
        if cross == .stretch {
            return ASDisplayNode()
                .sized(width: 12 * CGFloat($0))
        } else {
            return ASDisplayNode()
                .sized(CGSize(same: 12 * CGFloat($0)))
        }
    }
    private let titleTextNode: VATextNode
    private let cross: ASStackLayoutAlignItems

    init(title: String, selection: String, cross: ASStackLayoutAlignItems) {
        self.cross = cross
        self.titleTextNode = getTitleTextNode(string: title, selection: selection)

        super.init()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 8, cross: .stretch) {
            titleTextNode
                .padding(.horizontal(16))
            Row(spacing: 8, cross: cross) {
                exampleNodes
            }
            .minConstrained(height: cross == .stretch ? 48 : 0)
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        exampleNodes.forEach {
            $0.backgroundColor = theme.systemGray
        }
    }
}
