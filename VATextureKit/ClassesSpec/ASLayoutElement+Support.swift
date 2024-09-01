//
//  ASLayoutElement+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

public extension ASLayoutElement {

    /// Sets the preferred size of the layout element.
    ///
    /// - Parameters:
    ///   -  size: The preferred size to be set for the layout element.
    /// - Returns: The modified `ASLayoutElement` with the preferred size set.
    @discardableResult
    func sized(_ size: CGSize) -> Self {
        style.preferredSize = size

        return self
    }

    /// Sets the preferred width and/or height of the layout element.
    ///
    /// - Parameters:
    ///   - width: The preferred width in `points` to be set for the layout element. If `nil`, the width will not be modified. Defaults to `nil`
    ///   - height: The preferred height in `points` to be set for the layout element. If `nil`, the height will not be modified. Defaults to `nil`
    /// - Returns: The modified `ASLayoutElement` with the width and/or height set.
    @discardableResult
    @inline(__always) @inlinable func sized(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        sized(width: width.map { .points($0) }, height: height.map { .points($0) })
    }

    /// Sets the preferred width and/or height of the layout element.
    ///
    /// - Parameters:
    ///   - width: The preferred width to be set for the layout element. If `nil`, the width will not be modified. Defaults to `nil`
    ///   - height: The preferred height to be set for the layout element. If `nil`, the height will not be modified. Defaults to `nil`
    /// - Returns: The modified `ASLayoutElement` with the width and/or height set.
    @discardableResult
    func sized(width: ASDimension? = nil, height: ASDimension? = nil) -> Self {
        #if DEBUG
        assert(width != nil || height != nil)
        #endif
        if let width {
            style.width = width
        }
        if let height {
            style.height = height
        }

        return self
    }

    /// Sets the flex properties (`flexShrink`, `flexGrow`, and `flexBasis`) of the layout element.
    ///
    /// - Parameters:
    ///   - shrink: The flex shrink factor to be set for the layout element. If `nil`, the `flexShrink` will not be modified. Defaults to `nil`
    ///   - grow: The flex grow factor to be set for the layout element. If `nil`, the `flexGrow` will not be modified. Defaults to `nil`
    ///   - basisPercent: The flex basis as a fraction percent to be set for the layout element. If `nil`, the `flexBasis` will not be modified. Defaults to `nil`
    /// - Returns: Returns: The modified `ASLayoutElement` with the flex properties set.
    @discardableResult
    func flex(shrink: CGFloat? = nil, grow: CGFloat? = nil, basisPercent: CGFloat? = nil) -> Self {
        #if DEBUG
        assert(shrink != nil || grow != nil || basisPercent != nil)
        #endif
        if let shrink {
            style.flexShrink = shrink
        }
        if let grow {
            style.flexGrow = grow
        }
        if let basisPercent {
            #if DEBUG
            assert((0...100) ~= basisPercent, "ASDimension fraction percent must be between 0 and 100.")
            #endif
            style.flexBasis = .fraction(percent: basisPercent)
        }

        return self
    }

    /// Sets the `flexShrink` property of the layout element.
    ///
    /// - Parameters:
    ///   - shrink: The flex shrink factor to be set for the layout element.
    /// - Returns: Returns: The modified `ASLayoutElement` with the flex properties set.
    @discardableResult
    func shrink(_ shrink: CGFloat) -> Self {
        style.flexShrink = shrink

        return self
    }

    /// Sets the `flexGrow` property of the layout element.
    ///
    /// - Parameters:
    ///   - grow: The flex grow factor to be set for the layout element.
    /// - Returns: Returns: The modified `ASLayoutElement` with the flex properties set.
    @discardableResult
    func grow(_ grow: CGFloat) -> Self {
        style.flexGrow = grow

        return self
    }

    /// Sets the `flexBasis` property of the layout element.
    ///
    /// - Parameters:
    ///   - basis: The flex basis to be set for the layout element.
    /// - Returns: Returns: The modified `ASLayoutElement` with the flex properties set.
    @discardableResult
    func basis(_ basis: ASDimension) -> Self {
        style.flexBasis = basis

        return self
    }

    /// Sets the `flexBasis` property of the layout element.
    ///
    /// - Parameters:
    ///   - percent: The flex basis as a fraction percent to be set for the layout element.
    /// - Returns: Returns: The modified `ASLayoutElement` with the flex properties set.
    @discardableResult
    func basis(percent: CGFloat) -> Self {
        #if DEBUG
        assert((0...100) ~= percent, "ASDimension fraction percent must be between 0 and 100.")
        #endif
        style.flexBasis = .fraction(percent: percent)

        return self
    }

    /// Sets the maximum size constraint for the layout element.
    ///
    /// - Parameter size: The maximum size constraint to be set for the layout element.
    /// - Returns: The modified `ASLayoutElement` with the maximum size constraint set.
    @discardableResult
    func maxConstrained(size: CGSize) -> Self {
        style.maxSize = size

        return self
    }

    /// Sets the maximum width and/or height constraint for the layout element.
    ///
    /// - Parameters:
    ///   - width: The maximum width constraint in `points` to be set for the layout element. If `nil`, the maximum width will not be modified. Defaults to `nil`
    ///   - height: The maximum height constraint in `points` to be set for the layout element. If `nil`, the maximum height will not be modified. Defaults to `nil`
    /// - Returns: The modified `ASLayoutElement` with the maximum width and/or height constraint set.
    @discardableResult
    @inline(__always) @inlinable func maxConstrained(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        maxConstrained(width: width.map { .points($0) }, height: height.map { .points($0) })
    }

    /// Sets the maximum width and/or height constraint for the layout element.
    ///
    /// - Parameters:
    ///   - width: The maximum width constraint to be set for the layout element. If `nil`, the maximum width will not be modified. Defaults to `nil`
    ///   - height: The maximum height constraint to be set for the layout element. If `nil`, the maximum height will not be modified. Defaults to `nil`
    /// - Returns: The modified `ASLayoutElement` with the maximum width and/or height constraint set.
    @discardableResult
    func maxConstrained(width: ASDimension? = nil, height: ASDimension? = nil) -> Self {
        #if DEBUG
        assert(width != nil || height != nil)
        #endif
        if let width {
            style.maxWidth = width
        }
        if let height {
            style.maxHeight = height
        }

        return self
    }

    /// Sets the minimum size constraint for the layout element.
    ///
    /// - Parameter size: The minimum size constraint to be set for the layout element.
    /// - Returns: The modified `ASLayoutElement` with the minimum size constraint set.
    @discardableResult
    func minConstrained(size: CGSize) -> Self {
        style.minSize = size

        return self
    }

    /// Sets the minimum width and/or height constraint for the layout element.
    ///
    /// - Parameters:
    ///   - width: The minimum width constraint in `points` to be set for the layout element. If `nil`, the minimum width will not be modified. Defaults to `nil`
    ///   - height: The minimum height constraint in `points` to be set for the layout element. If `nil`, the minimum height will not be modified. Defaults to `nil`
    /// - Returns: The modified `ASLayoutElement` with the minimum width and/or height constraint set.
    @discardableResult
    @inline(__always) @inlinable func minConstrained(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        minConstrained(width: width.map { .points($0) }, height: height.map { .points($0) })
    }

    /// Sets the minimum width and/or height constraint for the layout element.
    ///
    /// - Parameters:
    ///   - width: The minimum width constraint to be set for the layout element. If `nil`, the minimum width will not be modified. Defaults to `nil`
    ///   - height: The minimum height constraint to be set for the layout element. If `nil`, the minimum height will not be modified. Defaults to `nil`
    /// - Returns: The modified `ASLayoutElement` with the minimum width and/or height constraint set.
    @discardableResult
    func minConstrained(width: ASDimension? = nil, height: ASDimension? = nil) -> Self {
        #if DEBUG
        assert(width != nil || height != nil)
        #endif
        if let width {
            style.minWidth = width
        }
        if let height {
            style.minHeight = height
        }

        return self
    }

    /// Creates an `ASRelativeLayoutSpec` with the layout element relatively positioned.
    ///
    /// - Parameters:
    ///   - horizontal: The horizontal position option for the layout element in the `ASRelativeLayoutSpec`. Defaults to `.start`.
    ///   - vertical: The vertical position option for the layout element in the `ASRelativeLayoutSpec`. Defaults to `.start`.
    ///   - sizing: The sizing option for the `ASRelativeLayoutSpec`. Defaults to `.minimumSize`.
    /// - Returns: An `ASRelativeLayoutSpec` with the layout element relatively positioned.
    @inline(__always) @inlinable func relatively(
        horizontal: ASRelativeLayoutSpecPosition = .start,
        vertical: ASRelativeLayoutSpecPosition = .start,
        sizing: ASRelativeLayoutSpecSizingOption = .minimumSize
    ) -> ASRelativeLayoutSpec {
        .init(
            horizontalPosition: horizontal,
            verticalPosition: vertical,
            sizingOption: sizing,
            child: self
        )
    }

    /// Creates an `ASAbsoluteLayoutSpec` with the layout element absolutely positioned.
    ///
    /// - Parameters:
    ///   - preferredSize: The size of the layout element in the `ASAbsoluteLayoutSpec`.
    ///   - layoutPosition: The position of the layout element in the `ASAbsoluteLayoutSpec`.
    ///   - sizing: The sizing option for the `ASAbsoluteLayoutSpec`. Defaults to `.default`.
    /// - Returns: An `ASAbsoluteLayoutSpec` with the layout element absolutely positioned.
    func absolutely(
        preferredSize: CGSize? = nil,
        layoutPosition: CGPoint? = nil,
        sizing: ASAbsoluteLayoutSpecSizing = .default
    ) -> ASAbsoluteLayoutSpec {
        if let preferredSize {
            style.preferredSize = preferredSize
        }
        if let layoutPosition {
            style.layoutPosition = layoutPosition
        }

        return .init(
            sizing: sizing,
            children: [self]
        )
    }

    /// Creates an `ASAbsoluteLayoutSpec` with the layout element absolutely positioned.
    ///
    /// - Parameters:
    ///   - frame: The frame representing the position and size of the layout element in the `ASAbsoluteLayoutSpec`.
    ///   - sizing: The sizing option for the `ASAbsoluteLayoutSpec`. Defaults to `.default`.
    /// - Returns: An `ASAbsoluteLayoutSpec` with the layout element absolutely positioned.
    func absolutely(
        frame: CGRect,
        sizing: ASAbsoluteLayoutSpecSizing = .default
    ) -> ASAbsoluteLayoutSpec {
        style.preferredSize = frame.size
        style.layoutPosition = frame.origin

        return .init(
            sizing: sizing,
            children: [self]
        )
    }

    /// Creates an `ASBackgroundLayoutSpec` with the layout element as the foreground and the provided element as the background.
    ///
    /// - Parameter element: The layout element to be used as the background in the `ASBackgroundLayoutSpec`.
    /// - Returns: An `ASBackgroundLayoutSpec` with the layout element as the foreground and the provided element as the background.
    @inline(__always) @inlinable func background(_ element: any ASLayoutElement) -> ASBackgroundLayoutSpec {
        .init(child: self, background: element)
    }

    /// Creates an `ASOverlayLayoutSpec` with the layout element as the base and the provided element as the overlay.
    ///
    /// - Parameter element: The layout element to be used as the overlay in the `ASOverlayLayoutSpec`.
    /// - Returns: An `ASOverlayLayoutSpec` with the layout element as the base and the provided element as the overlay.
    @inline(__always) @inlinable func overlay(_ element: any ASLayoutElement) -> ASOverlayLayoutSpec {
        .init(child: self, overlay: element)
    }

    /// Creates an `ASRatioLayoutSpec` with the layout element and a specified aspect ratio.
    ///
    /// - Parameter multiplier: The aspect ratio multiplier to be set for the `ASRatioLayoutSpec`.
    /// - Returns: An `ASRatioLayoutSpec` with the layout element and the specified aspect ratio.
    @inline(__always) @inlinable func ratio(_ multiplier: CGFloat) -> ASRatioLayoutSpec {
        .init(ratio: multiplier, child: self)
    }

    /// Creates an `ASCenterLayoutSpec` with the layout element centered using specified centering and sizing options.
    ///
    /// - Parameters:
    ///   - centering: The centering options for the layout element in the `ASCenterLayoutSpec`. Defaults to `.XY`.
    ///   - sizing: The sizing options for the layout element in the `ASCenterLayoutSpec`. Defaults to `.minimumXY`.
    /// - Returns: An `ASCenterLayoutSpec` with the layout element centered using the specified centering and sizing options.
    @inline(__always) @inlinable func centered(
        _ centering: ASCenterLayoutSpecCenteringOptions = .XY,
        sizing: ASCenterLayoutSpecSizingOptions = .minimumXY
    ) -> ASCenterLayoutSpec {
        .init(
            centeringOptions: centering,
            sizingOptions: sizing,
            child: self
        )
    }

    /// Creates an `ASInsetLayoutSpec` with the layout element padded using the specified paddings.
    ///
    /// - Parameter paddings: An array of `VAPadding` representing the padding values for the layout element in the `ASInsetLayoutSpec`.
    /// - Returns: An `ASInsetLayoutSpec` with the layout element padded using the specified paddings.
    @inline(__always) @inlinable func padding(_ paddings: VAPadding...) -> ASInsetLayoutSpec {
        .init(insets: .init(paddings: paddings), child: self)
    }

    /// Creates an `ASWrapperLayoutSpec` with the layout element wrapped.
    ///
    /// - Returns: An `ASWrapperLayoutSpec` with the layout element wrapped.
    @inline(__always) @inlinable func wrapped() -> ASWrapperLayoutSpec {
        .init(layoutElement: self)
    }

    /// Creates an `ASCornerLayoutSpec` with the layout element placed at a corner of the layout.
    ///
    /// - Parameters:
    ///   - element: The layout element to be placed at the corner in the `ASCornerLayoutSpec`.
    ///   - location: The location of the corner where the element should be placed. Defaults to `.topRight`.
    ///   - offset: The offset in points to adjust the position of the corner element. Defaults to `.zero`.
    ///   - wrapsCorner: A Boolean value indicating whether the corner element should wrap around the corner. Defaults to `false`.
    /// - Returns: An `ASCornerLayoutSpec` with the layout element placed at the specified corner along with the provided customization options.
    func corner(
        _ element: any ASLayoutElement,
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

    /// Creates an `ASInsetLayoutSpec` with the layout element safely inset based on the specified safe area edges.
    ///
    /// - Parameters:
    ///   - edges: The safe area edges for which the layout element should be inset.
    ///   - node: The `ASDisplayNode` representing the container node that provides safe area information.
    /// - Returns: An `ASInsetLayoutSpec` with the layout element safely inset based on the specified safe area edges.
    @inline(__always) @inlinable func `safe`(edges: VASafeAreaEdge, in node: ASDisplayNode) -> ASInsetLayoutSpec {
        .init(insets: .init(paddings: mapToPaddings(edges: edges, in: node)), child: self)
    }

    /// Maps the specified safe area edges to an array of `VAPadding` representing the insets.
    ///
    /// - Parameters:
    ///   - edges: The safe area edges to be mapped to `VAPadding`.
    ///   - node: The `ASDisplayNode` representing the container node that provides safe area insets.
    /// - Returns: An array of `VAPadding` representing the insets for each edge based on the specified safe area edges.
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

public extension Array where Element: ASLayoutElement {

    /// Creates an `ASRatioLayoutSpec` array with a specified aspect ratio.
    ///
    ///   - Parameter multiplier: The aspect ratio multiplier to be set for the `ASRatioLayoutSpec`.
    /// - Returns: Container with the `ASRatioLayoutSpec`s.
    @discardableResult
    @inline(__always) @inlinable func ratio(_ multiplier: CGFloat) -> [ASRatioLayoutSpec] {
        map { $0.ratio(multiplier) }
    }

    /// Sets the preferred size for the layout elements contained within the container.
    ///
    /// - Parameters:
    ///   -  size: The preferred size to be set for the layout elements.
    /// - Returns: Container with the preferred size set for its layout elements.
    @discardableResult
    func sized(_ size: CGSize) -> Self {
        forEach { $0.sized(size) }

        return self
    }

    /// Sets the preferred width and/or height for the layout elements contained within the container.
    ///
    /// - Parameters:
    ///   - width: The preferred width in `points` to be set for the layout elements. If `nil`, the width will not be modified. Defaults to `nil`
    ///   - height: The preferred height in `points` to be set for the layout elements. If `nil`, the height will not be modified.
    /// - Returns: Container with the preferred width and/or height set for its layout elements.
    @discardableResult
    @inline(__always) @inlinable func sized(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        sized(width: width.map { .points($0) }, height: height.map { .points($0) })
    }

    /// Sets the preferred width and/or height for the layout elements contained within the container.
    ///
    /// - Parameters:
    ///   - width: The preferred width to be set for the layout elements. If `nil`, the width will not be modified. Defaults to `nil`
    ///   - height: The preferred height to be set for the layout elements. If `nil`, the height will not be modified.
    /// - Returns: Container with the preferred width and/or height set for its layout elements.
    @discardableResult
    func sized(width: ASDimension? = nil, height: ASDimension? = nil) -> Self {
        #if DEBUG
        assert(width != nil || height != nil)
        #endif
        forEach { $0.sized(width: width, height: height) }

        return self
    }

    /// Sets the flex properties for the layout elements contained within the container.
    ///
    /// - Parameters:
    ///   - shrink: The flex shrink factor to be set for the layout elements. If `nil`, the `shrink` will not be modified. Defaults to `nil`
    ///   - grow: The flex grow factor to be set for the layout elements. If `nil`, the `grow` will not be modified. Defaults to `nil`
    ///   - basisPercent: The flex basis as a fraction percent to be set for the layout elements. If `nil`, the `basisPercent` will not be modified. Defaults to `nil`
    /// - Returns: Container with the flex properties set for its layout elements.
    @discardableResult
    func flex(shrink: CGFloat? = nil, grow: CGFloat? = nil, basisPercent: CGFloat? = nil) -> Self {
        #if DEBUG
        assert(shrink != nil || grow != nil || basisPercent != nil)
        #endif
        forEach { $0.flex(shrink: shrink, grow: grow, basisPercent: basisPercent) }

        return self
    }

    /// Sets the maximum size constraint for the layout elements contained within the container.
    ///
    /// - Parameter size: The maximum size constraint to be set for the layout elements.
    /// - Returns: Container with the maximum size constraint set for its layout elements.
    @discardableResult
    func maxConstrained(size: CGSize) -> Self {
        forEach { $0.maxConstrained(size: size) }

        return self
    }

    /// Sets the maximum width and/or height constraint for the layout elements contained within the container.
    ///
    /// - Parameters:
    ///   - width: The maximum width constraint in `points` to be set for the layout elements. If `nil`, the maximum width will not be modified. Defaults to `nil`
    ///   - height: The maximum height in `points` constraint to be set for the layout elements. If `nil`, the maximum height will not be modified. Defaults to `nil`
    /// - Returns: Container with the maximum width and/or height constraint set for its layout elements.
    @discardableResult
    @inline(__always) @inlinable func maxConstrained(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        maxConstrained(width: width.map { .points($0) }, height: height.map { .points($0) })
    }

    /// Sets the maximum width and/or height constraint for the layout elements contained within the container.
    ///
    /// - Parameters:
    ///   - width: The maximum width constraint to be set for the layout elements. If `nil`, the maximum width will not be modified. Defaults to `nil`
    ///   - height: The maximum height constraint to be set for the layout elements. If `nil`, the maximum height will not be modified. Defaults to `nil`
    /// - Returns: Container with the maximum width and/or height constraint set for its layout elements.
    @discardableResult
    func maxConstrained(width: ASDimension? = nil, height: ASDimension? = nil) -> Self {
        #if DEBUG
        assert(width != nil || height != nil)
        #endif
        forEach { $0.maxConstrained(width: width, height: height) }

        return self
    }

    /// Sets the minimum size constraint for the layout elements contained within the container.
    ///
    /// - Parameter size: The minimum size constraint to be set for the layout elements.
    /// - Returns: Container with the minimum size constraint set for its layout elements.
    @discardableResult
    func minConstrained(size: CGSize) -> Self {
        forEach { $0.minConstrained(size: size) }

        return self
    }

    /// Sets the minimum width and/or height constraint for the layout elements contained within the container.
    ///
    /// - Parameters:
    ///   - width: The minimum width constraint in `points` to be set for the layout elements. If `nil`, the minimum width will not be modified. Defaults to `nil`
    ///   - height: The minimum height in `points` constraint to be set for the layout elements. If `nil`, the minimum height will not be modified. Defaults to `nil`
    /// - Returns: Container with the minimum width and/or height constraint set for its layout elements.
    @discardableResult
    @inline(__always) @inlinable func minConstrained(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        minConstrained(width: width.map { .points($0) }, height: height.map { .points($0) })
    }

    /// Sets the minimum width and/or height constraint for the layout elements contained within the container.
    ///
    /// - Parameters:
    ///   - width: The minimum width constraint to be set for the layout elements. If `nil`, the minimum width will not be modified. Defaults to `nil`
    ///   - height: The minimum height constraint to be set for the layout elements. If `nil`, the minimum height will not be modified. Defaults to `nil`
    /// - Returns: Container with the minimum width and/or height constraint set for its layout elements.
    @discardableResult
    func minConstrained(width: ASDimension? = nil, height: ASDimension? = nil) -> Self {
        #if DEBUG
        assert(width != nil || height != nil)
        #endif
        forEach { $0.minConstrained(width: width, height: height) }

        return self
    }
}

/// A set of options representing safe area edges.
public struct VASafeAreaEdge: RawRepresentable, OptionSet, Sendable {
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

// MARK: - Capitalized for beauty when used

public extension ASDisplayNode {

    /// Creates a layout spec that pads the provided layout element with `safeAreaInsets`.
    ///
    /// - Parameter layoutElement: A closure returning the layout element to be padded.
    /// - Returns: A layout spec that applies padding with `safeAreaInsets` to the provided layout element.
    @inline(__always) @inlinable func SafeArea(_ layoutElement: () -> any ASLayoutElement) -> ASLayoutSpec {
        layoutElement()
            .padding(.insets(safeAreaInsets))
    }

    /// Creates a layout spec that pads the provided layout element with custom edge `safeAreaInsets` based on the specified edges.
    ///
    /// - Parameters:
    ///   - edges: The edges of the safe area for which padding is applied.
    ///   - layoutElement: A closure returning the layout element to be padded.
    /// - Returns: A layout spec that applies padding with custom edge insets to the provided layout element.
    @inline(__always) @inlinable func SafeArea(edges: VASafeAreaEdge, _ layoutElement: () -> any ASLayoutElement) -> ASLayoutSpec {
        ASInsetLayoutSpec(
            insets: .init(paddings: mapToPaddings(edges: edges, in: self)),
            child: layoutElement()
        )
    }
}
