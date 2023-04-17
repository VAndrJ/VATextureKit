//
//  Stack.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//

import AsyncDisplayKit

public final class Stack: ASWrapperLayoutSpec {

    public init(
        @LayoutSpecBuilder content: () -> [ASLayoutElement]
    ) {
        super.init(layoutElements: content())
    }

    public override func calculateLayoutThatFits(_ constrainedSize: ASSizeRange) -> ASLayout {
        let children = self.children ?? []
        var rawSubLayouts: [ASLayout] = []
        var size = constrainedSize.min
        for child in children {
            let sublayout = child.layoutThatFits(constrainedSize, parentSize: constrainedSize.max)
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
