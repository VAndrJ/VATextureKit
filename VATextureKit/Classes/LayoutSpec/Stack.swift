//
//  Stack.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//

import AsyncDisplayKit

/// The `Stack` class is a wrapper around `ASStackLayoutSpec` for `depth towards` direction.
public final class Stack: ASWrapperLayoutSpec {

    /// Wrapper init, creates a new `Stack`
    ///
    /// - Parameters:
    ///   - content: A rewult builder closure that returns an array of `ASLayoutElement` objects, representing the child elements to be included in the horizontal stack.
    public init(@LayoutSpecBuilder content: () -> [ASLayoutElement]) {
        super.init(layoutElements: content())
    }

    public override func calculateLayoutThatFits(_ constrainedSize: ASSizeRange) -> ASLayout {
        var size = constrainedSize.min
        guard let children, !children.isEmpty else {
            return ASLayout(layoutElement: self, size: size)
        }

        var rawSubLayouts: [ASLayout] = []
        let parentSize = CGSize(
            width: constrainedSize.min.width == constrainedSize.max.width ? constrainedSize.min.width : ASLayoutElementParentDimensionUndefined,
            height: constrainedSize.min.height == constrainedSize.max.height ? constrainedSize.min.height : ASLayoutElementParentDimensionUndefined
        )
        // ASStackUnpositionedLayout is not public, so crutches.
        for child in children {
            var constrainingSize = parentSize
            if parentSize.width.isNaN {
                if child.style.width.unit == .points && child.style.width.value > 0 {
                    constrainingSize.width = child.style.width.value
                } else if child.style.minWidth.unit == .points && child.style.minWidth.value > 0 {
                    constrainingSize.width = child.style.minWidth.value
                }
            }
            if parentSize.width.isNaN {
                if child.style.height.unit == .points && child.style.height.value > 0 {
                    constrainingSize.height = child.style.height.value
                } else if child.style.minHeight.unit == .points && child.style.minHeight.value > 0 {
                    constrainingSize.height = child.style.minHeight.value
                }
            }
            let sublayout = child.layoutThatFits(constrainedSize, parentSize: constrainingSize)
            sublayout.position = .zero
            size.width = max(size.width, sublayout.size.width)
            size.height = max(size.height, sublayout.size.height)
        }
        for child in children {
            let sublayout = child.layoutThatFits(ASSizeRange(min: .zero, max: size))
            sublayout.position = .zero
            size.width = max(size.width, sublayout.size.width)
            size.height = max(size.height, sublayout.size.height)
            rawSubLayouts.append(sublayout)
        }
        for (i, child) in children.enumerated() {
            if let centerSpec = child as? ASCenterLayoutSpec {
                switch centerSpec.centeringOptions {
                case .X:
                    let x = (size.width - rawSubLayouts[i].size.width) * proportionOfAxisFor(position: .center)
                    rawSubLayouts[i].position = CGPoint(x: x, y: 0)
                case .Y:
                    let y = (size.height - rawSubLayouts[i].size.height) * proportionOfAxisFor(position: .center)
                    rawSubLayouts[i].position = CGPoint(x: 0, y: y)
                case .XY:
                    let x = (size.width - rawSubLayouts[i].size.width) * proportionOfAxisFor(position: .center)
                    let y = (size.height - rawSubLayouts[i].size.height) * proportionOfAxisFor(position: .center)
                    rawSubLayouts[i].position = CGPoint(x: x, y: y)
                default:
                    break
                }
            }
            if let relativeSpec = child as? ASRelativeLayoutSpec {
                let x = (size.width - rawSubLayouts[i].size.width) * proportionOfAxisFor(position: relativeSpec.horizontalPosition)
                let y = (size.height - rawSubLayouts[i].size.height) * proportionOfAxisFor(position: relativeSpec.verticalPosition)
                rawSubLayouts[i].position = CGPoint(x: x, y: y)
            }
        }
        
        return ASLayout(layoutElement: self, size: size, sublayouts: rawSubLayouts)
    }

    private func proportionOfAxisFor(position: ASRelativeLayoutSpecPosition) -> CGFloat {
        switch position {
        case .center:
            return 0.5
        case .end:
            return 1
        default:
            return 0
        }
    }
}
