//
//  VAImageNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 05.04.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

/// `VAImageNode` is a subclass of `ASImageNode` that provides additional theming capabilities. It allows customization of the image `tintColor` and `backgroundColor` based on the current theme.
open class VAImageNode: VASimpleImageNode, VACornerable, VAThemeObserver {
    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }
    /// A closure that provides the tint color based on the current theme.
    public var tintColorGetter: ((VATheme) -> UIColor)?
    /// A closure that provides the background color based on the current theme.
    public var backgroundColorGetter: ((VATheme) -> UIColor)?
    /// The corner rounding configuration for the node.
    public var corner: VACornerRoundingParameters {
        didSet {
            guard oldValue != corner else { return }

            updateCornerParameters()
        }
    }

    open override var tintColor: UIColor! {
        get { tintColorGetter?(theme) ?? .clear }
        set {
            tintColorGetter = { _ in newValue ?? .clear }
            updateTintColorIfAvailable(theme)
        }
    }
    
    var shouldConfigureTheme = true
    var isInitialTraits = true

    /// Initializes the instance with optional parameters.
    ///
    /// - Parameters:
    ///   - image: The image to display in the node.
    ///   - size: The preferred size of the image node.
    ///   - contentMode: The content mode for displaying the image.
    ///   - tintColor: A closure that determines the tint color based on the theme.
    ///   - backgroundColor: A closure that determines the background color based on the theme.
    ///   - corner: The corner rounding configuration for the image node.   
    public init(
        image: UIImage? = nil,
        size: CGSize? = nil,
        contentMode: UIView.ContentMode? = nil,
        tintColor: ((VATheme) -> UIColor)? = nil,
        backgroundColor: ((VATheme) -> UIColor)? = nil,
        corner: VACornerRoundingParameters = .default
    ) {
        self.tintColorGetter = tintColor
        self.backgroundColorGetter = backgroundColor
        self.corner = corner

        super.init()

        if let image {
            self.image = image
        }
        if let size {
            self.style.preferredSize = size
        }
        if let contentMode {
            self.contentMode = contentMode
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        updateCornerParameters()
        appContext.themeManager.addThemeObserver(self)
        #if DEBUG || targetEnvironment(simulator)
        addDebugLabel()
        #endif
    }

    open override func viewDidEnterDisplayState() {
        super.viewDidEnterDisplayState()

        if shouldConfigureTheme {
            configureTheme(theme)
            shouldConfigureTheme = false
        }
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateCornerProportionalIfNeeded()
    }

    // Dirty hack ro redraw image
    open override func asyncTraitCollectionDidChange(withPreviousTraitCollection previousTraitCollection: ASPrimitiveTraitCollection) {
        var previousTraitCollection = previousTraitCollection
        if isInitialTraits {
            isInitialTraits = false
        } else {
            if previousTraitCollection.horizontalSizeClass != asyncTraitCollection().horizontalSizeClass ||
                previousTraitCollection.verticalSizeClass != asyncTraitCollection().verticalSizeClass {
                switch previousTraitCollection.userInterfaceStyle {
                case .dark:
                    previousTraitCollection.userInterfaceStyle = .light
                default:
                    previousTraitCollection.userInterfaceStyle = .dark
                }
            }
        }
        
        super.asyncTraitCollectionDidChange(withPreviousTraitCollection: previousTraitCollection)
    }

    /// Configures the node's theme elements based on the given theme.
    ///
    /// - Parameter theme: The theme to apply to the node.
    @MainActor
    @objc open func configureTheme(_ theme: VATheme) {
        updateTintColorIfAvailable(theme)
        updateBackgroundColorIfAvailable(theme)
    }

    /// Called when the app's theme changes. Configures the theme if the node is in the display state, otherwise sets `shouldConfigureTheme` to true.
    public func themeDidChanged(to newValue: VATheme) {
        if isInDisplayState {
            Task { @MainActor in
                configureTheme(newValue)
            }
        } else {
            shouldConfigureTheme = true
        }
    }

    /// Updates the node's tint color if a valid tint color is provided by the `tintColorGetter`.
    ///
    /// - Parameter theme: The theme to use for determining the tint color.
    open func updateTintColorIfAvailable(_ theme: VATheme) {
        if let color = tintColorGetter?(theme) {
            imageModificationBlock = ASImageNodeTintColorModificationBlock(color)
            setNeedsDisplay()
        }
    }

    /// Updates the node's background color if a valid background color is provided by the `backgroundColorGetter`.
    ///
    /// - Parameter theme: The theme to use for determining the background color.
    open func updateBackgroundColorIfAvailable(_ theme: VATheme) {
        if let color = backgroundColorGetter?(theme) {
            backgroundColor = color
        }
    }

    deinit {
        appContext.themeManager.removeThemeObserver(self)
    }
}
