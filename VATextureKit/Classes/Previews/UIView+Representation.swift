//
//  UIView+Representation.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 10.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

#if canImport(SwiftUI)
#if compiler(>=6.0)
public import SwiftUI
#else
import SwiftUI
#endif
import UIKit

public extension UIView {

    func sRepresentation(layout: VAPreviewLayout) -> AnyView {
        switch layout {
        case let .fixed(size):
            return VAUIViewRepresentable(view: self)
                .frame(width: size.width, height: size.height, alignment: .topLeading)
                .previewLayout(.sizeThatFits)
                .anyView
        case .auto:
            let size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

            return VAUIViewRepresentable(view: self)
                .frame(width: ceil(size.width), height: ceil(size.height), alignment: .topLeading)
                .previewLayout(.sizeThatFits)
                .anyView
        case let .flexibleWidth(height):
            frame.size = CGSize(width: UIView.layoutFittingExpandedSize.width, height: height)
            setNeedsLayout()
            layoutIfNeeded()
            let size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

            return VAUIViewRepresentable(view: self)
                .frame(width: ceil(size.width), height: height, alignment: .topLeading)
                .previewLayout(.sizeThatFits)
                .anyView
        case let .flexibleHeight(width):
            frame.size = CGSize(width: width, height: UIView.layoutFittingExpandedSize.height)
            setNeedsLayout()
            layoutIfNeeded()
            let size = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

            return VAUIViewRepresentable(view: self)
                .frame(width: width, height: ceil(size.height), alignment: .topLeading)
                .previewLayout(.sizeThatFits)
                .anyView
        case .inherited:
            return VAUIViewRepresentable(view: self)
                .frame(width: frame.width, height: frame.height, alignment: .topLeading)
                .previewLayout(.sizeThatFits)
                .anyView
        case .undefined:
            return VAUIViewRepresentable(view: self)
                .previewLayout(.sizeThatFits)
                .anyView
        }
    }
}
#endif
