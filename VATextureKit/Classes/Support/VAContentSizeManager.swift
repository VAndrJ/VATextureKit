//
//  VAContentSizeManager.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

open class VAContentSizeManager {
    public static let contentSizeDidChangedNotification = Notification.Name("VAContentSizeManager.contentSizeDidChangedNotification")
    
    public private(set) var contentSize: UIContentSizeCategory
    
    public init(contentSize: UIContentSizeCategory) {
        self.contentSize = contentSize
    }
    
    public func updateIfNeeded(contentSize: UIContentSizeCategory) {
        if self.contentSize != contentSize {
            self.contentSize = contentSize
            NotificationCenter.default.post(
                name: Self.contentSizeDidChangedNotification,
                object: self
            )
        }
    }
}
