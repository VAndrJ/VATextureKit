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
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        contentNode.layoutSpecBlock = { [weak self] node, constrainedSize in
            self?.layoutSpec(node, constrainedSize) ?? ASLayoutSpec()
        }
    }
    
    public func setNeedsDisplay() {
        contentNode.setNeedsDisplay()
    }
    
    open func layoutSpec(_ node: ASDisplayNode, _ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        fatalError("implement")
    }
}

// swiftlint:disable identifier_name
public extension VANodeController {
    
    // Capitalized for beauty when used
    func SafeArea(_ layoutSpec: () -> ASLayoutSpec) -> ASLayoutSpec {
        layoutSpec()
            .padding(.insets(contentNode.safeAreaInsets))
    }
    
    // Capitalized for beauty when used
    func SafeArea(_ layoutElement: () -> ASLayoutElement) -> ASLayoutSpec {
        layoutElement()
            .padding(.insets(contentNode.safeAreaInsets))
    }
}
