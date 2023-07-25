//
//  CGRect+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 25.07.2023.
//

import Foundation

public extension CGRect {
    var position: CGPoint { CGPoint(x: midX, y: midY) }
}
