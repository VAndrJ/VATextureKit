//
//  VATheme.swift
//  VATextureKit
//
//  Created by VAndrJ on 18.02.2023.
//

import UIKit

public protocol VATheme {
    var statusBarStyle: UIStatusBarStyle { get }
    var barStyle: UIBarStyle { get }
    var background: UIColor { get }
    var text: UIColor { get }
}
