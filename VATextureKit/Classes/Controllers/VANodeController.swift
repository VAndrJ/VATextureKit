//
//  VANodeController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 22.03.2023.
//

import AsyncDisplayKit

open class VANodeController: VAViewController<ASDisplayNode> {
    
    public init() {
        let node = ASDisplayNode()
        node.automaticallyManagesSubnodes = true
        node.automaticallyRelayoutOnSafeAreaChanges = true
        
        super.init(node: node)

        configureLayoutElements()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        contentNode.layoutSpecBlock = { [weak self] _, constrainedSize in
            self?.layoutSpecThatFits(constrainedSize) ?? ASLayoutSpec()
        }
        configure()
        bind()
    }
    
    public func setNeedsDisplay() {
        contentNode.setNeedsDisplay()
    }
    
    open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        #if DEBUG
        assertionFailure("implement")
        #endif
        
        return ASLayoutSpec()
    }

    open func configureLayoutElements() {}

    open func bind() {}

    open func configure() {}
}

// MARK: - Capitalized for beauty when used

// swiftlint:disable identifier_name
public extension VANodeController {

    func SafeArea(_ layoutSpec: () -> ASLayoutSpec) -> ASLayoutSpec {
        contentNode.SafeArea(layoutSpec)
    }

    func SafeArea(_ layoutElement: () -> ASLayoutElement) -> ASLayoutSpec {
        contentNode.SafeArea(layoutElement)
    }

    func SafeArea(edges: VASafeAreaEdge, _ layoutSpec: () -> ASLayoutSpec) -> ASLayoutSpec {
        contentNode.SafeArea(edges: edges, layoutSpec)
    }

    func SafeArea(edges: VASafeAreaEdge, _ layoutElement: () -> ASLayoutElement) -> ASLayoutSpec {
        contentNode.SafeArea(edges: edges, layoutElement)
    }
}
