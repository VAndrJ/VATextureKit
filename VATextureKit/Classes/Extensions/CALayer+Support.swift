//
//  CALayer+Support.swift
//  Pods
//
//  Created by VAndrJ on 9/2/24.
//

import QuartzCore

#if compiler(>=6.0)
extension CALayer: @retroactive @unchecked Sendable {}
#else
extension CALayer: @unchecked Sendable {}
#endif
