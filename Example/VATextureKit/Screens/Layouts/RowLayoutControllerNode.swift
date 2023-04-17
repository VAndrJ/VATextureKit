//
//  RowLayoutControllerNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class RowLayoutControllerNode: VASafeAreaDisplayNode {
    private var exampleMainAxisNodes: [ASDisplayNode] { (0..<4).map { _ in ASDisplayNode().sized(CGSize(same: 48)) } }
    private var exampleCrossAxisNodes: [ASDisplayNode] { (1...4).map { ASDisplayNode().sized(CGSize(same: 12 * CGFloat($0))) } }
    private func getTitleTextNode(string: String, selection: String) -> VATextNode {
        VATextNode(
            string: string,
            color: { $0.label },
            descriptor: .monospaced,
            secondary: [.init(strings: [selection], color: { $0.secondaryLabel }, descriptor: .monospaced)]
        )
    }
    private lazy var startMainAxisTitleTextNode = getTitleTextNode(string: "Main axis .start\nCross axis .start", selection: ".start")
    private lazy var endMainAxisTitleTextNode = getTitleTextNode(string: "Main axis .end", selection: ".end")
    private lazy var centerMainAxisTitleTextNode = getTitleTextNode(string: "Main axis .center", selection: ".center")
    private lazy var spaceBetweenMainAxisTitleTextNode = getTitleTextNode(string: "Main axis .spaceBetween", selection: ".spaceBetween")
    private lazy var spaceAroundMainAxisTitleTextNode = getTitleTextNode(string: "Main axis .spaceAround", selection: ".spaceAround")
    private lazy var centerCrossAxisTitleTextNode = getTitleTextNode(string: "Cross axis .center", selection: ".center")
    private lazy var endCrossAxisTitleTextNode = getTitleTextNode(string: "Cross axis .end", selection: ".end")
    private lazy var stretchCrossAxisTitleTextNode = getTitleTextNode(string: "Cross axis .stretch", selection: ".stretch")
    private lazy var startMainAxisExampleNodes = exampleMainAxisNodes
    private lazy var endMainAxisExampleNodes = exampleMainAxisNodes
    private lazy var centerMainAxisExampleNodes = exampleMainAxisNodes
    private lazy var spaceBetweenMainAxisExampleNodes = exampleMainAxisNodes
    private lazy var spaceAroundMainAxisExampleNodes = exampleMainAxisNodes
    private lazy var centerCrossAxisExampleNodes = exampleCrossAxisNodes
    private lazy var endCrossAxisExampleNodes = exampleCrossAxisNodes
    private lazy var stretchCrossAxisExampleNodes = (1...4).map { ASDisplayNode().sized(width: 12 * CGFloat($0)) }
    private lazy var scrollNode = VAScrollNode(data: .init(contentInset: UIEdgeInsets(vertical: 24)))

    override init() {
        super.init()

        scrollNode.layoutSpecBlock = { [weak self] _, size in
            self?.layoutSpecScroll(constrainedSize: size) ?? ASLayoutSpec()
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            scrollNode
        }
    }

    func layoutSpecScroll(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        Column(spacing: 16, cross: .stretch) {
            startMainAxisTitleTextNode
                .padding(.top(24), .horizontal(16))
            Row(spacing: 8) {
                startMainAxisExampleNodes
            }

            endMainAxisTitleTextNode
                .padding(.top(24), .horizontal(16))
            Row(spacing: 8, main: .end) {
                endMainAxisExampleNodes
            }

            centerMainAxisTitleTextNode
                .padding(.top(24), .horizontal(16))
            Row(spacing: 8, main: .center) {
                centerMainAxisExampleNodes
            }

            spaceBetweenMainAxisTitleTextNode
                .padding(.top(24), .horizontal(16))
            Row(spacing: 8, main: .spaceBetween) {
                spaceBetweenMainAxisExampleNodes
            }

            spaceAroundMainAxisTitleTextNode
                .padding(.top(24), .horizontal(16))
            Row(spacing: 8, main: .spaceAround) {
                spaceAroundMainAxisExampleNodes
            }

            centerCrossAxisTitleTextNode
                .padding(.top(24), .horizontal(16))
            Row(spacing: 8, cross: .center) {
                centerCrossAxisExampleNodes
            }

            endCrossAxisTitleTextNode
                .padding(.top(24), .horizontal(16))
            Row(spacing: 8, cross: .end) {
                endCrossAxisExampleNodes
            }

            stretchCrossAxisTitleTextNode
                .padding(.top(24), .horizontal(16))
            Row(spacing: 8, cross: .stretch) {
                stretchCrossAxisExampleNodes
            }
            .sized(height: 48)
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
        [
            startMainAxisExampleNodes,
            endMainAxisExampleNodes,
            centerMainAxisExampleNodes,
            spaceBetweenMainAxisExampleNodes,
            spaceAroundMainAxisExampleNodes,
            centerCrossAxisExampleNodes,
            endCrossAxisExampleNodes,
            stretchCrossAxisExampleNodes,
            stretchCrossAxisExampleNodes,
        ].forEach { $0.forEach { $0.backgroundColor = theme.systemGray } }
    }
}
