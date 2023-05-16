//
//  UIApplication+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//

import UIKit

public extension UIApplication {
    var orientation: UIInterfaceOrientation {
        if #available(iOS 13.0, *) {
            return connectedScenes.compactMap { $0 as? UIWindowScene }.first(where: { $0.windows.contains { $0.isKeyWindow } })?.interfaceOrientation ?? statusBarOrientation
        } else {
            return statusBarOrientation
        }
    }
    var isAlbum: Bool {
        switch orientation {
        case .landscapeLeft, .landscapeRight: return true
        default: return false
        }
    }
}
