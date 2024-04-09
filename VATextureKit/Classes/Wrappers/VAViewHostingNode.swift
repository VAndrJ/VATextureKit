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
    private(set) lazy var hostingController = _LayoutTrackingHostingController(
        rootView: viewGetter(),
        shouldLayout: { [weak self] in self?.setNeedsLayout() }
    )

    private let viewGetter: @MainActor () -> AnyView
    private let sizing: WrapperNodeSizing
    private var shouldAddToController = true

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - body: A closure returning the View instance to be wrapped.
    ///   - sizing: The sizing option to apply to the wrapped view.
    ///   - corner: Corner parameters.
    public init(
        body: @MainActor @escaping () -> some View,
        sizing: WrapperNodeSizing,
        corner: VACornerRoundingParameters = .default
    ) {
        self.sizing = sizing
        self.viewGetter = { AnyView(body()) }

        super.init(corner: corner)

        // To trigger `layout()` in any spec and avoid zero-sized frames.
        minConstrained(size: CGSize(same: 1))
    }

    @MainActor
    open override func didLoad() {
        super.didLoad()

        view.addSubview(hostingController.view)
        hostingController.view.backgroundColor = .clear
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
                if !size.height.isPixelEqual(to: style.height.value) {
                    let height = size.height.pixelRounded(.up)
                    hostingController.view.frame = .init(width: bounds.width, height: height)
                    style.height = .points(height)
                    var newFrame = frame
                    newFrame.size.height = height
                    frame = newFrame
                    setNeedsLayout()
                }
            } else {
                if hostingController.view.frame != bounds {
                    hostingController.view.frame = bounds
                }
            }
        case .viewWidth:
            let size = hostingController.view.systemLayoutSizeFitting(.init(
                width: UIView.layoutFittingExpandedSize.width,
                height: bounds.height
            ))
            if !size.width.isPixelEqual(to: bounds.width) {
                if !size.width.isPixelEqual(to: style.width.value) {
                    let width = size.width.pixelRounded(.up)
                    hostingController.view.frame = .init(width: width, height: bounds.height)
                    style.width = .points(width)
                    var newFrame = frame
                    newFrame.size.width = width
                    frame = newFrame
                    setNeedsLayout()
                }
            } else {
                if hostingController.view.frame != bounds {
                    hostingController.view.frame = bounds
                }
            }
        case .viewSize:
            let size = hostingController.view.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
            if !size.height.isPixelEqual(to: bounds.height) || !size.width.isPixelEqual(to: bounds.width) {
                if !size.height.isPixelEqual(to: style.preferredSize.height) || !size.width.isPixelEqual(to: style.preferredSize.width) {
                    let newSize = CGSize(
                        width: size.width.pixelRounded(.up),
                        height: size.height.pixelRounded(.up)
                    )
                    hostingController.view.frame = .init(size: newSize)
                    style.preferredSize = newSize
                    var newFrame = frame
                    newFrame.size = newSize
                    frame = newFrame
                    setNeedsLayout()
                }
            } else {
                if hostingController.view.frame != bounds {
                    hostingController.view.frame = bounds
                }
            }
        }
    }
}

@available (iOS 13.0, *)
class _LayoutTrackingHostingController<Content: View>: UIHostingController<Content> {
    let shouldLayout: () -> Void

    init(rootView: Content, shouldLayout: @escaping () -> Void) {
        self.shouldLayout = shouldLayout

        super.init(rootView: rootView)
    }

    @MainActor
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.invalidateIntrinsicContentSize()
        shouldLayout()
    }
}
#endif
