//
//  SendableASContextTransitioning.swift
//  Pods
//
//  Created by VAndrJ on 9/1/24.
//

import AsyncDisplayKit

final class SendableASContextTransitioning: NSObject, ASContextTransitioning, @unchecked Sendable {
    let context: any ASContextTransitioning

    init(context: any ASContextTransitioning) {
        self.context = context
    }

    func isAnimated() -> Bool {
        context.isAnimated()
    }

    func layout(forKey key: String) -> ASLayout? {
        context.layout(forKey: key)
    }

    func constrainedSize(forKey key: String) -> ASSizeRange {
        context.constrainedSize(forKey: key)
    }

    func subnodes(forKey key: String) -> [ASDisplayNode] {
        context.subnodes(forKey: key)
    }

    func insertedSubnodes() -> [ASDisplayNode] {
        context.insertedSubnodes()
    }

    func removedSubnodes() -> [ASDisplayNode] {
        context.removedSubnodes()
    }

    func initialFrame(for node: ASDisplayNode) -> CGRect {
        context.initialFrame(for: node)
    }

    func finalFrame(for node: ASDisplayNode) -> CGRect {
        context.finalFrame(for: node)
    }

    func completeTransition(_ didComplete: Bool) {
        context.completeTransition(didComplete)
    }
}
