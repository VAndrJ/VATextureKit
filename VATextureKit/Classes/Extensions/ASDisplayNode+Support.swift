//
//  ASDisplayNode+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 18.02.2023.
//

@_exported import AsyncDisplayKit

public extension ASDisplayNode {

    enum BlendMode: String, CaseIterable {
        case color = "colorBlendMode"
        case colorBurn = "colorBurnBlendMode"
        case colorDodge = "colorDodgeBlendMode"
        case darken = "darkenBlendMode"
        case difference = "differenceBlendMode"
        case divide = "divideBlendMode"
        case exclusion = "exclusionBlendMode"
        case hard = "hardLightBlendMode"
        case hue = "hueBlendMode"
        case lighten = "lightenBlendMode"
        case linearBurn = "linearBurnBlendMode"
        case linearDodge = "linearDodgeBlendMode"
        case linearLight = "linearLightBlendMode"
        case luminosity = "luminosityBlendMode"
        case multiply = "multiplyBlendMode"
        case overlay = "overlayBlendMode"
        case pinLight = "pinLightBlendMode"
        case saturation = "saturationBlendMode"
        case screen = "screenBlendMode"
        case softLight = "softLightBlendMode"
        case supstract = "subtractBlendMode"
        case vividLight = "vividLightBlendMode"
    }

    var blendMode: BlendMode? {
        get { (layer.compositingFilter as? String).flatMap(BlendMode.init(rawValue:)) }
        set { layer.compositingFilter = newValue?.rawValue }
    }

    enum CompositingFilter: String, CaseIterable {
        case addition
        case maximum
        case minimum
        case multiply
        case sourceAtop
        case sourceIn
        case sourceOut
        case sourceOver
    }

    var compositingFilter: CompositingFilter? {
        get { (layer.compositingFilter as? String).flatMap(CompositingFilter.init(rawValue:)) }
        set { layer.compositingFilter = newValue?.rawValue }
    }

    func setNeedsLayoutAnimated(shouldMeasureAsync: Bool = false, completion: (() -> Void)? = nil) {
        transitionLayout(withAnimation: true, shouldMeasureAsync: shouldMeasureAsync, measurementCompletion: completion)
    }
}

#if DEBUG || targetEnvironment(simulator)
public extension ASDisplayNode {
    static var shouldDebugLabelBeHidden = true

    func addDebugLabel(
        addition: String? = nil,
        offset: CGSize = .zero,
        position: NSLayoutConstraint.Attribute = .bottom,
        side: NSLayoutConstraint.Attribute = .trailing
    ) {
        guard !isLayerBacked, !Self.shouldDebugLabelBeHidden else { return }

        let className = (String(describing: type(of: self)) as NSString).lastPathComponent
        let debugLabel = UILabel()
        debugLabel.font = .systemFont(ofSize: 6, weight: .ultraLight)
        debugLabel.tag = -42
        debugLabel.backgroundColor = .lightText.withAlphaComponent(0.32)
        debugLabel.textColor = .darkText.withAlphaComponent(0.68)
        debugLabel.text = [className, addition].compactMap { $0 }.joined(separator: " ")
        debugLabel.isUserInteractionEnabled = true
        debugLabel.isAccessibilityElement = false
        view.addAutolayoutSubview(debugLabel)
        debugLabel
            .toSuper(position, constant: offset.height, isSafe: true)
            .toSuper(side, constant: offset.width, isSafe: true)
            .size(height: 6)
        debugLabel.addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(onTapLabel(_:))
        ))
        debugLabel.isHidden = Self.shouldDebugLabelBeHidden
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onToggleDebug(_:)),
            name: .init(rawValue: "hidedebugelements"),
            object: nil
        )
    }
    
    @objc private func onTapLabel(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began, let label = sender.view as? UILabel else { return }

        print("copied", label.text ?? "")
        UIPasteboard.general.string = label.text
    }

    @objc private func onToggleDebug(_ notification: Notification) {
        removeDebugLabel()
    }
    
    func removeDebugLabel() {
        Self.shouldDebugLabelBeHidden = true
        view.subviews.first(where: { $0.tag == -42 })?.isHidden = true
    }
}
#endif
