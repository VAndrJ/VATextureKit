//
//  ASDisplayNode+Representation.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 10.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKitSpec

public extension ASDisplayNode {

    func loadForPreview() {
        ASTraitCollectionPropagateDown(
            self,
            ASPrimitiveTraitCollectionFromUITraitCollection(UITraitCollection.current)
        )
        setNeedsDisplay()
        recursivelyEnsureDisplaySynchronously(true)
        ASDisplayNodePerformBlockOnEveryNode(nil, self, true) {
            if let node = $0 as? ASCollectionNode {
                node.loadCollectionForPreview()
            } else if let node = $0 as? ASTableNode {
                node.loadTableForPreview()
            } else {
                $0.setNeedsDisplay()
                $0.recursivelyEnsureDisplaySynchronously(true)
            }
        }
    }

    func loadForSnapshot() {
        ASTraitCollectionPropagateDown(
            self,
            ASPrimitiveTraitCollectionFromUITraitCollection(UITraitCollection.current)
        )
        displaysAsynchronously = false
        setNeedsDisplay()
        recursivelyEnsureDisplaySynchronously(true)
        ASDisplayNodePerformBlockOnEveryNode(nil, self, true) {
            if let node = $0 as? ASCollectionNode {
                node.displaysAsynchronously = false
                node.loadCollectionForPreview()
            } else if let node = $0 as? ASTableNode {
                node.displaysAsynchronously = false
                node.loadTableForPreview()
            } else {
                $0.displaysAsynchronously = false
                $0.setNeedsDisplay()
                $0.recursivelyEnsureDisplaySynchronously(true)
            }
        }
    }
}

public extension ASCollectionNode {

    func loadCollectionForPreview() {
        ASTraitCollectionPropagateDown(
            self,
            ASPrimitiveTraitCollectionFromUITraitCollection(UITraitCollection.current)
        )
        reloadData()
        layer.removeAllAnimations()
        waitUntilAllUpdatesAreProcessed()
        setNeedsDisplay()
        recursivelyEnsureDisplaySynchronously(true)
        ASDisplayNodePerformBlockOnEveryNode(nil, self, true) {
            $0.setNeedsDisplay()
            $0.recursivelyEnsureDisplaySynchronously(true)
        }
    }
}

extension ASTableNode {

    func loadTableForPreview() {
        ASTraitCollectionPropagateDown(
            self,
            ASPrimitiveTraitCollectionFromUITraitCollection(UITraitCollection.current)
        )
        reloadData()
        layer.removeAllAnimations()
        waitUntilAllUpdatesAreProcessed()
        setNeedsDisplay()
        recursivelyEnsureDisplaySynchronously(true)
        ASDisplayNodePerformBlockOnEveryNode(nil, self, true) {
            $0.setNeedsDisplay()
            $0.recursivelyEnsureDisplaySynchronously(true)
        }
    }
}

#if canImport(SwiftUI)
import SwiftUI
import AsyncDisplayKit

@available (iOS 13.0, *)
public extension ASDisplayNode {

    @MainActor
    func sRepresentation(layout: VAPreviewLayout) -> AnyView {
        let node: ASDisplayNode
        if self.isLayerBacked {
            node = ASDisplayNode()
            node.addSubnode(self)
            node.layoutSpecBlock = { _, _ in self.wrapped() }
        } else {
            node = self
        }
        let sizeThatFits: CGSize = node.layoutThatFits(ASSizeRange(
            min: .init(width: layout.minSize.width, height: layout.minSize.height),
            max: .init(width: layout.maxSize.width, height: layout.maxSize.height)
        )).size
        node.bounds = .init(origin: .zero, size: sizeThatFits)
        node.loadForPreview()

        return node.view.sRepresentation(layout: .inherited)
    }
}
#endif
