//
//  ASScrollDirection+Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 23.07.2023.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

public extension ASScrollDirection {
    /// A predefined `ASScrollDirectionVerticalDirections` constant in Swift way.
    static let vertical = ASScrollDirectionVerticalDirections
    /// A predefined `ASScrollDirectionHorizontalDirections` constant in Swift way.
    static let horizontal = ASScrollDirectionHorizontalDirections
}
