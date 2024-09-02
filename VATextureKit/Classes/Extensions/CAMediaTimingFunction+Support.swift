//
//  CAMediaTimingFunction+Support.swift
//  Pods
//
//  Created by VAndrJ on 9/2/24.
//

#if compiler(>=6.0)
extension CAMediaTimingFunction: @retroactive @unchecked Sendable {}
#else
extension CAMediaTimingFunction: @unchecked Sendable {}
#endif
