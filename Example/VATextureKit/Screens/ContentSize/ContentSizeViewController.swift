//
//  ContentSizeViewController.swift
//  VATextureKit_Example
//
//  Created by VAndrJ on 20.02.2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

class ContentSizeViewController: VAViewController<ContentSizeControllerNode> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bind()
    }
    
    private func configure() {
        title = "Content size"
        updateContentSizeLabel()
    }
    
    private func bind() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeDidChanged(_:)),
            name: VAContentSizeManager.contentSizeDidChangedNotification,
            object: appContext.contentSizeManager
        )
    }
    
    @objc private func contentSizeDidChanged(_ notification: Notification) {
        updateContentSizeLabel()
    }
    
    private func updateContentSizeLabel() {
        contentNode.contentSizeTextNode.text = appContext.contentSizeManager.contentSize.rawValue
    }
}
