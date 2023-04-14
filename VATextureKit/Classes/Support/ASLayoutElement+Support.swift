//
//  ASLayoutElement+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

public extension Array where Element: ASLayoutElement {

    @discardableResult
    func sized(_ size: CGSize) -> Self {
        forEach { $0.sized(size) }
        return self
    }

    @discardableResult
    func sized(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        assert(width != nil || height != nil)
        forEach { $0.sized(width: width, height: height) }
        return self
    }

    @discardableResult
    func sized(width: ASDimension? = nil, height: ASDimension? = nil) -> Self {
        assert(width != nil || height != nil)
        forEach { $0.sized(width: width, height: height) }
        return self
    }

    @discardableResult
    func flex(shrink: CGFloat? = nil, grow: CGFloat? = nil, basisPercent: CGFloat? = nil) -> Self {
        assert(shrink != nil || grow != nil || basisPercent != nil)
        forEach { $0.flex(shrink: shrink, grow: grow, basisPercent: basisPercent) }
        return self
    }

    @discardableResult
    func maxConstrained(size: CGSize) -> Self {
        forEach { $0.maxConstrained(size: size) }
        return self
    }

    @discardableResult
    func maxConstrained(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        assert(width != nil || height != nil)
        forEach { $0.maxConstrained(width: width, height: height) }
        return self
    }

    @discardableResult
    func maxConstrained(width: ASDimension? = nil, height: ASDimension? = nil) -> Self {
        assert(width != nil || height != nil)
        forEach { $0.maxConstrained(width: width, height: height) }
        return self
    }

    @discardableResult
    func minConstrained(size: CGSize) -> Self {
        forEach { $0.minConstrained(size: size) }
        return self
    }

    @discardableResult
    func minConstrained(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        assert(width != nil || height != nil)
        forEach { $0.minConstrained(width: width, height: height) }
        return self
    }

    @discardableResult
    func minConstrained(width: ASDimension? = nil, height: ASDimension? = nil) -> Self {
        assert(width != nil || height != nil)
        forEach { $0.minConstrained(width: width, height: height) }
        return self
    }
}

public extension ASLayoutElement {

    @discardableResult
    func sized(_ size: CGSize) -> Self {
        style.preferredSize = size
        return self
    }

    @discardableResult
    func sized(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        assert(width != nil || height != nil)
        if let width {
            style.width = ASDimension(unit: .points, value: width)
        }
        if let height {
            style.height = ASDimension(unit: .points, value: height)
        }
        return self
    }

    @discardableResult
    func sized(width: ASDimension? = nil, height: ASDimension? = nil) -> Self {
        assert(width != nil || height != nil)
        if let width {
            style.width = width
        }
        if let height {
            style.height = height
        }
        return self
    }

    @discardableResult
    func flex(shrink: CGFloat? = nil, grow: CGFloat? = nil, basisPercent: CGFloat? = nil) -> Self {
        assert(shrink != nil || grow != nil || basisPercent != nil)
        if let shrink {
            style.flexShrink = shrink
        }
        if let grow {
            style.flexGrow = grow
        }
        if let basisPercent {
            assert((0...100) ~= basisPercent, "ASDimension fraction percent must be between 0 and 100.")
            style.flexBasis = ASDimensionMake(.fraction, basisPercent / 100)
        }
        return self
    }

    @discardableResult
    func maxConstrained(size: CGSize) -> Self {
        style.maxSize = size
        return self
    }

    @discardableResult
    func maxConstrained(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        assert(width != nil || height != nil)
        if let width {
            style.maxWidth = ASDimension(unit: .points, value: width)
        }
        if let height {
            style.maxHeight = ASDimension(unit: .points, value: height)
        }
        return self
    }

    @discardableResult
    func maxConstrained(width: ASDimension? = nil, height: ASDimension? = nil) -> Self {
        assert(width != nil || height != nil)
        if let width {
            style.maxWidth = width
        }
        if let height {
            style.maxHeight = height
        }
        return self
    }

    @discardableResult
    func minConstrained(size: CGSize) -> Self {
        style.minSize = size
        return self
    }

    @discardableResult
    func minConstrained(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        assert(width != nil || height != nil)
        if let width {
            style.minWidth = ASDimension(unit: .points, value: width)
        }
        if let height {
            style.minHeight = ASDimension(unit: .points, value: height)
        }
        return self
    }

    @discardableResult
    func minConstrained(width: ASDimension? = nil, height: ASDimension? = nil) -> Self {
        assert(width != nil || height != nil)
        if let width {
            style.minWidth = width
        }
        if let height {
            style.minHeight = height
        }
        return self
    }

    func relatively(
        horizontal: ASRelativeLayoutSpecPosition,
        vertical: ASRelativeLayoutSpecPosition,
        sizing: ASRelativeLayoutSpecSizingOption = .minimumSize
    ) -> ASRelativeLayoutSpec {
        ASRelativeLayoutSpec(
            horizontalPosition: horizontal,
            verticalPosition: vertical,
            sizingOption: sizing,
            child: self
        )
    }

    func background(_ element: ASLayoutElement) -> ASBackgroundLayoutSpec {
        ASBackgroundLayoutSpec(
            child: self,
            background: element
        )
    }

    func overlay(_ element: ASLayoutElement) -> ASOverlayLayoutSpec {
        ASOverlayLayoutSpec(
            child: self,
            overlay: element
        )
    }

    func ratio(_ multiplier: CGFloat) -> ASRatioLayoutSpec {
        ASRatioLayoutSpec(
            ratio: multiplier,
            child: self
        )
    }

    func centered(
        centering: ASCenterLayoutSpecCenteringOptions = .XY,
        sizing: ASCenterLayoutSpecSizingOptions = .minimumXY
    ) -> ASCenterLayoutSpec {
        ASCenterLayoutSpec(
            centeringOptions: centering,
            sizingOptions: sizing,
            child: self
        )
    }

    func padding(_ paddings: VAPadding...) -> ASInsetLayoutSpec {
        ASInsetLayoutSpec(
            insets: UIEdgeInsets(paddings: paddings),
            child: self
        )
    }

    func wrapped() -> ASWrapperLayoutSpec {
        ASWrapperLayoutSpec(layoutElement: self)
    }

    func corner(
        _ element: ASLayoutElement,
        location: ASCornerLayoutLocation = .topRight,
        offset: CGPoint = .zero,
        wrapsCorner: Bool = false
    ) -> ASCornerLayoutSpec {
        let spec = ASCornerLayoutSpec(
            child: self,
            corner: element,
            location: location
        )
        spec.offset = offset
        spec.wrapsCorner = wrapsCorner
        return spec
    }

    func `safe`(edges: VASafeAreaEdge, in node: ASDisplayNode) -> ASLayoutSpec {
        ASInsetLayoutSpec(
            insets: UIEdgeInsets(paddings: mapToPaddings(edges: edges, in: node)),
            child: self
        )
    }

    func mapToPaddings(edges: VASafeAreaEdge, in node: ASDisplayNode) -> [VAPadding] {
        var paddings: [VAPadding] = []
        if edges.contains(.top) {
            paddings.append(.top(node.safeAreaInsets.top))
        }
        if edges.contains(.left) {
            paddings.append(.left(node.safeAreaInsets.left))
        }
        if edges.contains(.bottom) {
            paddings.append(.bottom(node.safeAreaInsets.bottom))
        }
        if edges.contains(.right) {
            paddings.append(.right(node.safeAreaInsets.right))
        }
        return paddings
    }
}

public struct VASafeAreaEdge: RawRepresentable, OptionSet {
    public var rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static let top = VASafeAreaEdge(rawValue: 1 << 1)
    public static let left = VASafeAreaEdge(rawValue: 1 << 2)
    public static let bottom = VASafeAreaEdge(rawValue: 1 << 3)
    public static let right = VASafeAreaEdge(rawValue: 1 << 4)
    public static let vertical: VASafeAreaEdge = [top, bottom]
    public static let horizontal: VASafeAreaEdge = [left, right]
    public static let all: VASafeAreaEdge = [top, left, bottom, right]
}
