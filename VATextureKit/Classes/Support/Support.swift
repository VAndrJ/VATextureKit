//
//  Support.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 11.03.2024.
//

@_exported import AsyncDisplayKit
@_exported import VATextureKitSpec

public func mainActorEscaped<R>(_ closure: @MainActor @escaping () -> R) -> () -> R {
    closure
}
