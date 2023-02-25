//
//  AlertViewController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 25.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import AsyncDisplayKit
import VATextureKit

class AlertViewController: VAViewController<AlertControllerNode> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func showAlert() {
        let alertController = VAAlertController(
            title: "title",
            message: "message",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func bind() {
        contentNode.buttonNode.onTap = { [weak self] in
            self?.showAlert()
        }
    }
}
