//
//  LoadingCellNode.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 26.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import VATextureKit

class LoadingCellNode: VACellNode {
    
    init(viewModel: LoadingCellNodeViewModel) {
        super.init()
        
        style.height = ASDimension(unit: .points, value: viewModel.height)
    }
    
    override func layout() {
        super.layout()
        
        if isVisible {
            startAnimating()
        }
    }
    
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
        
        startAnimating()
    }
    
    override func didExitVisibleState() {
        super.didExitVisibleState()
        
        stopAnimating()
    }
    
    func startAnimating() {
        let light = theme.systemBackground.withAlphaComponent(0).cgColor
        let alpha = theme.systemBackground.cgColor
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(
            x: -bounds.width,
            y: 0,
            width: 3 * bounds.width,
            height: bounds.height
        )
        gradient.startPoint = CGPoint(x: 0.5, y: 1)
        gradient.endPoint = CGPoint(x: 0.5, y: 0)
        gradient.locations = [0.4, 0.5, 0.6]
        layer.mask = gradient
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 0.3
        animation.repeatCount = .greatestFiniteMagnitude
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        gradient.colors = [light, alpha, light]
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopAnimating() {
        layer.mask = nil
    }
    
    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemGreen
        if isVisible {
            startAnimating()
        }
    }
}

class LoadingCellNodeViewModel: CellViewModel {
    let height: CGFloat

    internal init(height: CGFloat = 100) {
        self.height = height
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available (iOS 13.0, *)
struct LoadingCellNode_Preview: PreviewProvider {
    static var previews: some View {
        LoadingCellNode(viewModel: .init(height: 100))
            .sRepresentation(layout: .fixed(CGSize(same: 100)))
            .previewLayout(.sizeThatFits)
    }
}
#endif
