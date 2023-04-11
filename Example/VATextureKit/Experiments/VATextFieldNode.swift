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

class VATextFieldNode: VADisplayNode {
    public private(set) lazy var child: UITextField = childGetter()

    private let childGetter: () -> _VATextField

    override init() {
        self.childGetter = { _VATextField() }
        
        super.init()
    }

    open override func didLoad() {
        super.didLoad()

        view.addSubview(child)
    }

    open override func layout() {
        super.layout()

        if child.frame.height.rounded(.up) != bounds.height.rounded(.up) || child.frame.height.isZero {
            child.frame.size = CGSize(width: bounds.width, height: UIView.layoutFittingExpandedSize.height)
            child.setNeedsLayout()
            child.layoutIfNeeded()
            let size = child.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let height = size.height.rounded(.up)
            child.frame = CGRect(x: 0, y: 0, width: bounds.width, height: height)
            style.height = ASDimension(unit: .points, value: height)
        } else {
            child.frame = bounds
        }
    }
}

private class _VATextField: UITextField {
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
