//
//  VASizedViewWrapperNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 11.04.2023.
//

import UIKit
import AsyncDisplayKit

public enum WrapperNodeSizing {
    // Adjust node height based on child autosizing, width remains node-based
    case viewHeight
    // Adjust node width based on child autosizing, height remains node-based
    case viewWidth
    // Adjust both node height and width based on child autosizing
    case viewSize
}

/// A custom `ASDisplayNode` subclass for wrapping autolayout and self-sizing `UIView`s with various sizing options.
open class VASizedViewWrapperNode<T: UIView>: VADisplayNode {
    /// The wrapped UIView instance.
    @MainActor
    public private(set) lazy var child: T = childGetter()

    private let childGetter: @MainActor () -> T
    private let sizing: WrapperNodeSizing
    // To avoid `systemLayoutSizeFitting` calculation issues
    private var cHeight: NSLayoutConstraint?
    private var cWidth: NSLayoutConstraint?

    /// Creates an instance of `VASizedViewWrapperNode`.
    ///
    /// - Parameters:
    ///   - childGetter: A closure returning the UIView instance to be wrapped.
    ///   - sizing: The sizing option to apply to the wrapped view.
    ///   - corner: Corner parameters.
    public init(
        childGetter: @MainActor @escaping () -> T,
        sizing: WrapperNodeSizing,
        corner: VACornerRoundingParameters = .default
    ) {
        self.sizing = sizing
        self.childGetter = childGetter

        super.init(corner: corner)

        // To trigger `layout()` in any spec and avoid zero-sized frames.
        minConstrained(size: .init(same: 1))
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.addAutolayoutSubview(child)
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        switch sizing {
        case .viewHeight:
            if let cWidth {
                cWidth.constant = bounds.width
            } else {
                cWidth = child.widthAnchor.constraint(equalToConstant: bounds.width)
                cWidth?.priority = .init(999)
                cWidth?.isActive = true
            }
            let size = child.systemLayoutSizeFitting(.init(
                width: bounds.width,
                height: UIView.layoutFittingExpandedSize.height
            ))
            if !size.height.isPixelEqual(to: bounds.height) {
                if !size.height.isPixelEqual(to: style.height.value) {
                    let height = size.height.pixelRounded(.up)
                    child.frame = .init(width: bounds.width, height: height)
                    style.height = .points(height)
                    var newFrame = frame
                    newFrame.size.height = height
                    frame = newFrame
                    setNeedsLayout()
                }
            } else {
                if child.frame != bounds {
                    child.frame = bounds
                }
            }
        case .viewWidth:
            if let cHeight {
                cHeight.constant = bounds.height
            } else {
                cHeight = child.heightAnchor.constraint(equalToConstant: bounds.height)
                cHeight?.priority = .init(999)
                cHeight?.isActive = true
            }
            let size = child.systemLayoutSizeFitting(.init(
                width: UIView.layoutFittingExpandedSize.width,
                height: bounds.height
            ))
            if !size.width.isPixelEqual(to: bounds.width) {
                if !size.width.isPixelEqual(to: style.width.value) {
                    let width = size.width.pixelRounded(.up)
                    child.frame = .init(width: width, height: bounds.height)
                    style.width = .points(width)
                    var newFrame = frame
                    newFrame.size.width = width
                    frame = newFrame
                    setNeedsLayout()
                }
            } else {
                if child.frame != bounds {
                    child.frame = bounds
                }
            }
        case .viewSize:
            let size = child.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
            if !size.height.isPixelEqual(to: bounds.height) || !size.width.isPixelEqual(to: bounds.width) {
                if !size.height.isPixelEqual(to: style.preferredSize.height) || !size.width.isPixelEqual(to: style.preferredSize.width) {
                    let newSize = CGSize(
                        width: size.width.pixelRounded(.up),
                        height: size.height.pixelRounded(.up)
                    )
                    child.frame = .init(size: newSize)
                    style.preferredSize = newSize
                    var newFrame = frame
                    newFrame.size = newSize
                    frame = newFrame
                    setNeedsLayout()
                }
            } else {
                if child.frame != bounds {
                    child.frame = bounds
                }
            }
        }
    }
}
