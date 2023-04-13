//
//  UIViewController+Support.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import UIKit

extension UIViewController {

    func configureTabBarItem(title: String, image: UIImage?, label: String? = nil) {
        tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)
        tabBarItem.accessibilityLabel = label
    }
}
