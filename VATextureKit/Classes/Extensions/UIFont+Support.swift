//
//  UIFont+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//

import Foundation

public extension UIFont {
    var monospacedDigitFont: UIFont { .init(descriptor: fontDescriptor.monospacedDigitFontDescriptor, size: 0) }
}
