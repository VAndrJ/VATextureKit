//
//  ShimmersScreenNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 23.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct ShimmersNavigationIdentity: DefaultNavigationIdentity {}

final class ShimmersScreenNode: ScreenNode {
    private lazy var acrossWindowSynchronizedTextNode = VATextNode(text: "Shimmer across window synchronized")
    private lazy var acrossWindowShimmer0Node = _ShimmerExampleNode(data: .init())
        .flex(grow: 1)
    private lazy var acrossWindowShimmer1Node = _ShimmerExampleNode(data: .init())
        .flex(grow: 1)
    private lazy var acrossWindowShimmer2Node = _ShimmerExampleNode(data: .init())
        .flex(grow: 1)

    private lazy var acrossWindowNotSynchronizedTextNode = VATextNode(text: "Shimmer across window not synchronized")
    private lazy var notSynchronizedShimmer0Node = _ShimmerExampleNode(data: .init(isSynchronized: false))
        .flex(grow: 1)
    private lazy var notSynchronizedShimmer1Node = _ShimmerExampleNode(data: .init(isSynchronized: false))
        .flex(grow: 1)
    private lazy var notSynchronizedShimmer2Node = _ShimmerExampleNode(data: .init(isSynchronized: false))
        .flex(grow: 1)

    private lazy var acrossNodeSynchronizedTextNode = VATextNode(text: "Shimmer across node synchronized")
    private lazy var notAcrossWindowShimmer0Node = _ShimmerExampleNode(data: .init(isAcrossWindow: false))
        .flex(grow: 1)
    private lazy var notAcrossWindowShimmer1Node = _ShimmerExampleNode(data: .init(isAcrossWindow: false))
        .flex(grow: 1)
    private lazy var notAcrossWindowShimmer2Node = _ShimmerExampleNode(data: .init(isAcrossWindow: false))
        .flex(grow: 1)

    override func didLoad() {
        super.didLoad()

        // To trigger shimmer update.
        mainAsync(after: 0.4) { [self] in
            acrossWindowShimmer1Node.didEnterVisibleState()
            notSynchronizedShimmer1Node.didEnterVisibleState()
        }
        mainAsync(after: 0.8) { [weak self] in
            guard let self else { return }
            
            acrossWindowShimmer2Node.didEnterVisibleState()
            notSynchronizedShimmer2Node.didEnterVisibleState()
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(spacing: 64, cross: .stretch) {
                Column(spacing: 16, cross: .stretch) {
                    acrossWindowSynchronizedTextNode
                    Row(spacing: 8) {
                        acrossWindowShimmer0Node
                        acrossWindowShimmer1Node
                        acrossWindowShimmer2Node
                    }
                }
                Column(spacing: 16, cross: .stretch) {
                    acrossWindowNotSynchronizedTextNode
                    Row(spacing: 8) {
                        notSynchronizedShimmer0Node
                        notSynchronizedShimmer1Node
                        notSynchronizedShimmer2Node
                    }
                }
                Column(spacing: 16, cross: .stretch) {
                    acrossNodeSynchronizedTextNode
                    Row(spacing: 8) {
                        notAcrossWindowShimmer0Node
                        notAcrossWindowShimmer1Node
                        notAcrossWindowShimmer2Node
                    }
                }
            }
            .padding(.all(16))
        }
    }

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemBackground
    }
}

private class _ShimmerExampleNode: VAShimmerNode {
    private lazy var tileNode = VAShimmerTileNode(corner: .init(radius: .fixed(8)))
        .minConstrained(height: 50)

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        tileNode
            .wrapped()
    }
}
