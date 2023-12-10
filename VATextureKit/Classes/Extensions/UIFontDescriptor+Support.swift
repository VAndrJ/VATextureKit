//
//  UIFontDescriptor+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 17.04.2023.
//

import UIKit

public extension UIFontDescriptor {
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings: [[UIFontDescriptor.FeatureKey: Int]]
        if #available(iOS 15, *) {
            fontDescriptorFeatureSettings = [
                [
                    UIFontDescriptor.FeatureKey.type: kNumberSpacingType,
                    UIFontDescriptor.FeatureKey.selector: kMonospacedNumbersSelector
                ]
            ]
        } else {
            fontDescriptorFeatureSettings = [
                [
                    UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
                ]
            ]
        }
        let fontDescriptorAttributes = [
            UIFontDescriptor.AttributeName.featureSettings: fontDescriptorFeatureSettings
        ]
        let fontDescriptor = addingAttributes(fontDescriptorAttributes)

        return fontDescriptor
    }
}
