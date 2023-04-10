//
//  VAPreviewLayout.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 10.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

#if canImport(SwiftUI)
import UIKit

@available (iOS 13.0, *)
public enum VAPreviewLayout {
    case auto
    case inherited
    case fixed(CGSize)
    case flexibleWidth(height: CGFloat)
    case flexibleHeight(width: CGFloat)
    case undefined
}

@available (iOS 13.0, *)
extension VAPreviewLayout {
    var minSize: CGSize {
        switch self {
        case .auto, .inherited, .undefined:
            return CGSize(same: 0)
        case let .fixed(size):
            return size
        case let .flexibleHeight(width):
            return CGSize(width: width, height: 0)
        case let .flexibleWidth(height):
            return CGSize(width: 0, height: height)
        }
    }
    var maxSize: CGSize {
        switch self {
        case .auto, .inherited, .undefined:
            return CGSize(same: .greatestFiniteMagnitude)
        case let .fixed(size):
            return size
        case let .flexibleHeight(width):
            return CGSize(width: width, height: .greatestFiniteMagnitude)
        case let .flexibleWidth(height):
            return CGSize(width: .greatestFiniteMagnitude, height: height)
        }
    }
}
#endif
