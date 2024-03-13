//
//  VAViewHostingNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 12.03.2024.
//

#if canImport(SwiftUI)
import SwiftUI
/// A custom `ASDisplayNode` subclass for wrapping SwiftUI `View` with various sizing options.
@available (iOS 13.0, *)
open class VAViewHostingNode: VADisplayNode {
    @MainActor
    private(set) lazy var hostingController = UIHostingController(rootView: viewGetter())

    private let viewGetter: @MainActor () -> AnyView
    private let sizing: WrapperNodeSizing
    private var shouldAddToController = true

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - body: A closure returning the View instance to be wrapped.
    ///   - sizing: The sizing option to apply to the wrapped view.
    public init(body: @MainActor @escaping () -> some View, sizing: WrapperNodeSizing) {
        self.sizing = sizing
        self.viewGetter = { AnyView(body()) }

        super.init()

        // To trigger `layout()` in any spec and avoid zero-sized frames.
        minConstrained(size: CGSize(same: 1))
    }

    @MainActor
    open override func didLoad() {
        super.didLoad()

        view.addSubview(hostingController.view)
        hostingController.view.backgroundColor = .clear
        hostingController.view.invalidateIntrinsicContentSize()
    }

    @MainActor
    open override func layout() {
        super.layout()

        if shouldAddToController, let closestViewController {
            let requiresControllerMove = hostingController.parent != closestViewController
            if requiresControllerMove {
                closestViewController.addChild(hostingController)
                shouldAddToController = false
            }
        }
        switch sizing {
        case .viewHeight:
            let size = hostingController.view.systemLayoutSizeFitting(.init(
                width: bounds.width,
                height: UIView.layoutFittingExpandedSize.height
            ))
            if !size.height.isPixelEqual(to: bounds.height) {
                let height = size.height.pixelRounded(.up)
                hostingController.view.frame = CGRect(width: bounds.width, height: height)
                style.height = .points(height)
                setNeedsLayout()
            } else {
                hostingController.view.frame = bounds
            }
        case .viewWidth:
            let size = hostingController.view.systemLayoutSizeFitting(.init(
                width: UIView.layoutFittingExpandedSize.width,
                height: bounds.height
            ))
            if !size.width.isPixelEqual(to: bounds.width) {
                let width = size.width.pixelRounded(.up)
                hostingController.view.frame = CGRect(width: width, height: bounds.height)
                style.width = .points(width)
                setNeedsLayout()
            } else {
                hostingController.view.frame = bounds
            }
        case .viewSize:
            let size = hostingController.view.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
            if !size.height.isPixelEqual(to: bounds.height) || !size.width.isPixelEqual(to: bounds.width) {
                hostingController.view.frame = CGRect(
                    width: size.width.pixelRounded(.up),
                    height: size.height.pixelRounded(.up)
                )
                style.preferredSize = size
                setNeedsLayout()
            } else {
                hostingController.view.frame = bounds
            }
        }
    }
}
#endif
