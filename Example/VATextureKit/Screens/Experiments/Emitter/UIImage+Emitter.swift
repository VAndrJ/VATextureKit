//
//  UIImage+Emitter.swift
//  VATextureKit_Example
//
//  Created by VAndrJ on 18.03.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import UIKit

extension UIImage {

    static func render(color: UIColor, size: CGSize, isEllipse: Bool = false) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)

        return UIGraphicsImageRenderer(bounds: rect).image { context in
            context.cgContext.setFillColor(color.cgColor)
            if isEllipse {
                context.cgContext.addEllipse(in: rect)
            } else {
                context.cgContext.addRect(rect)
            }
            context.cgContext.drawPath(using: .fill)
        }
    }

    static func render(layer: CALayer) -> UIImage {
        UIGraphicsImageRenderer(size: layer.bounds.size).image { context in
            layer.render(in: context.cgContext)
        }
    }
}
