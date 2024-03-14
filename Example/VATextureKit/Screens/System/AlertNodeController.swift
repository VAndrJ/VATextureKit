//
//  AlertNodeController.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 25.02.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

struct AlertNavigationIdentity: DefaultNavigationIdentity {}

// MARK: - ViewController as a View axample

final class AlertNodeController: VANodeController {
    struct Context {
        struct Navigation {
            let showAlert: (UIAlertController) -> Void
        }

        let navigation: Navigation
    }

    private let data: Context

    // MARK: - UI related code

    private let buttonNode = HapticButtonNode(title: "Show alert")

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        SafeArea {
            Column(cross: .stretch) {
                buttonNode
            }
        }
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        contentNode.backgroundColor = theme.systemBackground
    }

    // MARK: - Controller related code

    init(data: Context) {
        self.data = data

        super.init()
    }
    
    override func bind() {
        buttonNode.onTap = self ?> {
            $0.data.navigation.showAlert(VAAlertController(
                title: "title",
                message: "message",
                preferredStyle: .alert,
                actions: UIAlertAction(title: "OK", style: .cancel)
            ))
        }
    }
}
