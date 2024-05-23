//
//  UIApplication+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.03.2023.
//

import UIKit

public extension UIApplication {
    var orientation: UIInterfaceOrientation {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.windows.contains { $0.isKeyWindow } })?
            .interfaceOrientation ?? .portrait
    }
    var isAlbum: Bool {
        switch orientation {
        case .landscapeLeft, .landscapeRight: true
        default: false
        }
    }
}
