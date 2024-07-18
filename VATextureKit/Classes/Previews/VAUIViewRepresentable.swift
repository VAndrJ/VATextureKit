//
//  VAUIViewRepresentable.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 10.04.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

#if canImport(SwiftUI)
import UIKit
import SwiftUI

struct VAUIViewRepresentable: UIViewRepresentable {
    let view: UIView

    func makeUIView(context: Context) -> UIView { // unused:ignore
        view
    }

    func updateUIView(_ uiView: UIView, context: Context) {} // unused:ignore
}
#endif
