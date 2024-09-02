//
//  CGPath+Support.swift
//  VATextureKit
//
//  Created by VAndrJ on 8/31/24.
//

import CoreGraphics

#if compiler(>=6.0)
extension CGPath: @retroactive @unchecked Sendable {}
#else
extension CGPath: @unchecked Sendable {}
#endif
