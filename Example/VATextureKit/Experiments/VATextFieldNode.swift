//
//  VATextFieldNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 11.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import VATextureKit

class VATextFieldNode: VASizedViewWrapperNode<VATextField> {

    convenience init() {
        self.init(actorChildGetter: { VATextField() }, sizing: .viewHeight)
    }
}

class VATextField: UITextField {
    var textContainerInset: UIEdgeInsets {
        get { _textContainerInset }
        set {
            if newValue != _textContainerInset {
                _textContainerInset = newValue
                setNeedsLayout()
            }
        }
    }

    private var _textContainerInset: UIEdgeInsets = .zero

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(
            x: bounds.origin.x + _textContainerInset.left,
            y: bounds.origin.y + _textContainerInset.top,
            width: bounds.size.width - _textContainerInset.horizontal,
            height: bounds.size.height - _textContainerInset.vertical
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        textRect(forBounds: bounds)
    }
}
