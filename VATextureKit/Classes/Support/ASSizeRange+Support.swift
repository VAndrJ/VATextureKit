//
//  ASSizeRange+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//

import AsyncDisplayKit

public extension ASSizeRange {

    init(width: ClosedRange<CGFloat>, height: ClosedRange<CGFloat>) {
        self.init(
            min: CGSize(same: width.lowerBound),
            max: CGSize(same: width.upperBound)
        )
    }

    init(width: CGFloat, height: ClosedRange<CGFloat>) {
        self.init(
            min: CGSize(width: width, height: height.lowerBound),
            max: CGSize(width: width, height: height.upperBound)
        )
    }

    init(width: ClosedRange<CGFloat>, height: CGFloat) {
        self.init(
            min: CGSize(width: width.lowerBound, height: height),
            max: CGSize(width: width.upperBound, height: height)
        )
    }

    init(width: CGFloat, height: CGFloat) {
        let size = CGSize(width: width, height: height)
        self.init(
            min: size,
            max: size
        )
    }
}
