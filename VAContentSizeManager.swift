//
//  VAContentSizeManager.swift
//  VATextureKit
//
//  Created by VAndrJ on 20.02.2023.
//

import UIKit

open class VAContentSizeManager {
    public static let contentSizeDidChangedNotification = Notification.Name("VAThemeManager.themeDidChangedNotification")
    
    public private(set) var contentSize: UIContentSizeCategory
    
    public init(contentSize: UIContentSizeCategory) {
        self.contentSize = contentSize
    }
    
    public func updateIfNeeded(contentSize: UIContentSizeCategory) {
        if self.contentSize != contentSize {
            self.contentSize = contentSize
            NotificationCenter.default.post(name: Self.contentSizeDidChangedNotification, object: self)
        }
    }
}
