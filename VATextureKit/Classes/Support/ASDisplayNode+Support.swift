//
//  ASDisplayNode+Support.swift
//  VATextureKit
//
//  Created by VAndrJ on 18.02.2023.
//

#if DEBUG || targetEnvironment(simulator)
import AsyncDisplayKit

public extension ASDisplayNode {
    static var shouldDebugLabelBeHidden = true

    func addDebugLabel(
        addition: String? = nil,
        offset: CGSize = .zero,
        position: NSLayoutConstraint.Attribute = .bottom,
        side: NSLayoutConstraint.Attribute = .trailing
    ) {
        guard !isLayerBacked else { return }
        guard !Self.shouldDebugLabelBeHidden else { return }
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
            .toSuper(position, constant: offset.height)
            .toSuper(side, constant: offset.width)
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
        guard sender.state == .began else { return }
        guard let label = sender.view as? UILabel else { return }
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

