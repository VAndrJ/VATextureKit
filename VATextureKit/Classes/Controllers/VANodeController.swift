//
//  VANodeController.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 22.03.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
public import VATextureKitSpec
#else
import AsyncDisplayKit
import VATextureKitSpec
#endif

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

    /// Creates a layout spec that pads the provided layout element with `safeAreaInsets`.
    ///
    /// - Parameter layoutSpec: A closure returning the layout element to be padded.
    /// - Returns: A layout spec that applies padding with `safeAreaInsets` to the provided layout element.
    @inline(__always) @inlinable func SafeArea(_ layoutSpec: () -> ASLayoutSpec) -> ASLayoutSpec {
        contentNode.SafeArea(layoutSpec)
    }

    /// Creates a layout spec that pads the provided layout element with `safeAreaInsets`.
    ///
    /// - Parameter layoutElement: A closure returning the layout element to be padded.
    /// - Returns: A layout spec that applies padding with `safeAreaInsets` to the provided layout element.
    @inline(__always) @inlinable func SafeArea(_ layoutElement: () -> any ASLayoutElement) -> ASLayoutSpec {
        contentNode.SafeArea(layoutElement)
    }

    /// Creates a layout spec that pads the provided layout element with custom edge `safeAreaInsets` based on the specified edges.
    ///
    /// - Parameters:
    ///   - edges: The edges of the safe area for which padding is applied.
    ///   - layoutSpec: A closure returning the layout element to be padded.
    /// - Returns: A layout spec that applies padding with custom edge insets to the provided layout element.
    @inline(__always) @inlinable func SafeArea(edges: VASafeAreaEdge, _ layoutSpec: () -> ASLayoutSpec) -> ASLayoutSpec {
        contentNode.SafeArea(edges: edges, layoutSpec)
    }

    /// Creates a layout spec that pads the provided layout element with custom edge `safeAreaInsets` based on the specified edges.
    ///
    /// - Parameters:
    ///   - edges: The edges of the safe area for which padding is applied.
    ///   - layoutElement: A closure returning the layout element to be padded.
    /// - Returns: A layout spec that applies padding with custom edge insets to the provided layout element.
    @inline(__always) @inlinable func SafeArea(edges: VASafeAreaEdge, _ layoutElement: () -> any ASLayoutElement) -> ASLayoutSpec {
        contentNode.SafeArea(edges: edges, layoutElement)
    }
}
