//
//  ASLayoutElement+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import AsyncDisplayKit

public extension ASLayoutElement {

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

    func flex(shrink: CGFloat? = nil, grow: CGFloat? = nil) -> Self {
        assert(shrink != nil || grow != nil)
        if let shrink {
            style.flexShrink = shrink
        }
        if let grow {
            style.flexGrow = grow
        }
        return self
    }

    func maxConstrained(size: CGSize) -> Self {
        style.maxSize = size
        return self
    }

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

    func minConstrained(size: CGSize) -> Self {
        style.minSize = size
        return self
    }

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

    func sized(_ size: CGSize) -> Self {
        style.preferredSize = size
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

    func corner(_ element: ASLayoutElement, location: ASCornerLayoutLocation = .topRight) -> ASCornerLayoutSpec {
        ASCornerLayoutSpec(
            child: self,
            corner: element,
            location: location
        )
    }
}
