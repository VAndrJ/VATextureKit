//
//  ASDisplayNode+Representation.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 10.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI
import AsyncDisplayKit

@available (iOS 13.0, *)
public extension ASDisplayNode {

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
            min: CGSize(width: layout.minSize.width, height: layout.minSize.height),
            max: CGSize(width: layout.maxSize.width, height: layout.maxSize.height)
        )).size
        node.bounds = CGRect(origin: .zero, size: sizeThatFits)
        node.loadForPreview()
        return node.view.sRepresentation(layout: .inherited)
    }

    func loadForPreview() {
        ASTraitCollectionPropagateDown(self, ASPrimitiveTraitCollectionFromUITraitCollection(UITraitCollection.current))
        displaysAsynchronously = false
        ASDisplayNodePerformBlockOnEveryNode(nil, self, true) {
            $0.displaysAsynchronously = false
            $0.setNeedsDisplay()
            ($0 as? ASCollectionNode)?.loadCollectionForPreview()
            ($0 as? ASTableNode)?.loadTableForPreview()
        }
        recursivelyEnsureDisplaySynchronously(true)
    }
}

extension ASCollectionNode {

    func loadCollectionForPreview() {
        ASTraitCollectionPropagateDown(self, ASPrimitiveTraitCollectionFromUITraitCollection(UITraitCollection.current))
        displaysAsynchronously = false
        reloadData()
        waitUntilAllUpdatesAreProcessed()
        setNeedsLayout()
        layoutIfNeeded()
        ASDisplayNodePerformBlockOnEveryNode(nil, self, true) {
            $0.displaysAsynchronously = false
            $0.setNeedsDisplay()
        }
        recursivelyEnsureDisplaySynchronously(true)
        visibleNodes.forEach {
            $0.displaysAsynchronously = false
            ASDisplayNodePerformBlockOnEveryNode(nil, $0, true) {
                $0.displaysAsynchronously = false
                $0.setNeedsDisplay()
            }
            $0.recursivelyEnsureDisplaySynchronously(true)
        }
    }
}

extension ASTableNode {

    func loadTableForPreview() {
        ASTraitCollectionPropagateDown(self, ASPrimitiveTraitCollectionFromUITraitCollection(UITraitCollection.current))
        displaysAsynchronously = false
        reloadData()
        waitUntilAllUpdatesAreProcessed()
        setNeedsLayout()
        layoutIfNeeded()
        ASDisplayNodePerformBlockOnEveryNode(nil, self, true) {
            $0.displaysAsynchronously = false
            $0.setNeedsDisplay()
        }
        recursivelyEnsureDisplaySynchronously(true)
        visibleNodes.forEach {
            $0.displaysAsynchronously = false
            ASDisplayNodePerformBlockOnEveryNode(nil, $0, true) {
                $0.displaysAsynchronously = false
                $0.setNeedsDisplay()
            }
            $0.recursivelyEnsureDisplaySynchronously(true)
        }
    }
}
#endif
