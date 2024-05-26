//
//  VATouchesPassThroughDisplayNode.swift
//  VATextureKit
//
//  Created by VAndrJ on 26.05.2024.
//

import UIKit

open class VATouchesPassThroughDisplayNode: VADisplayNode {
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event), view != self.view {
            return view
        }

        return nil
    }
}
