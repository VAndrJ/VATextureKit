//
//  View+Support.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 10.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

#if canImport(SwiftUI)
public import SwiftUI

extension View {
    @inline(__always) @inlinable var anyView: AnyView { AnyView(self) }
}
#endif
