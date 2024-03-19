//
//  VAContentSizeManager.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

import UIKit

public protocol VAContentSizeObserver: AnyObject {

    func contentSizeDidChanged(to newValue: UIContentSizeCategory)
}

open class VAContentSizeManager {
    public private(set) var contentSize: UIContentSizeCategory

    private var contentSizeObservers: [ObjectIdentifier: () -> VAContentSizeObserver?] = [:]
    
    public init(contentSize: UIContentSizeCategory) {
        self.contentSize = contentSize
    }
    
    public func updateIfNeeded(contentSize: UIContentSizeCategory) {
        if self.contentSize != contentSize {
            self.contentSize = contentSize
            contentSizeObservers.values.forEach { $0()?.contentSizeDidChanged(to: contentSize) }
        }
    }

    public func addContentSizeObserver(_ observer: VAContentSizeObserver) {
        contentSizeObservers[ObjectIdentifier(observer)] = { [weak observer] in observer }
    }

    public func removeContentSizeObserver(_ observer: VAContentSizeObserver) {
        contentSizeObservers.removeValue(forKey: ObjectIdentifier(observer))
    }
}
