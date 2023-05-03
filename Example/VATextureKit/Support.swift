//
//  Support.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 24.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

let testImages = [
    "https://img.freepik.com/free-photo/grunge-paint-background_1409-1337.jpg?w=360",
    "https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?w=360",
    "https://img.freepik.com/free-photo/neon-tropical-monstera-leaf-banner_53876-138943.jpg?w=360",
    "https://img.freepik.com/free-vector/hand-painted-watercolor-pastel-sky-background_23-2148902771.jpg?w=360",
    "https://img.freepik.com/free-photo/odenwald-germany-is-pure-nature_181624-32381.jpg?w=360",
    "https://img.freepik.com/free-photo/galaxy-space-textured-background_53876-143060.jpg?w=360",
    "https://img.freepik.com/free-photo/3d-abstract-wave-pattern-background_53876-104422.jpg?w=360",
    "https://img.freepik.com/free-photo/lavender-field-sunset-near-valensole_268835-3910.jpg?w=360",
    "https://img.freepik.com/free-photo/falling-green-leaves-plum-tree-tea-isolated-white-background-food-levitation-concept-botanical-pattern-collage-close-up-copy-space-top-view_639032-210.jpg?w=360",
    "https://img.freepik.com/free-photo/glitch-effect-black-background_53876-129025.jpg?w=360",
    "https://img.freepik.com/free-photo/fresh-water-texture-background-transparent-liquid_53876-142911.jpg?w=360",
    "https://img.freepik.com/free-photo/coffee-beans-levitate-white-background_485709-33.jpg?w=360",
    "https://img.freepik.com/free-photo/galaxy-nature-aesthetic-background-starry-sky-mountain-remixed-media_53876-126761.jpg?w=360",
    "https://img.freepik.com/free-vector/gradient-blur-pink-blue-abstract-background_53876-117324.jpg?w=360",
    "https://img.freepik.com/free-vector/gradient-grainy-gradient-shape-set_23-2148971570.jpg?w=360",
    "https://img.freepik.com/free-vector/gradient-galaxy-background_23-2148983655.jpg?w=360",
    "https://img.freepik.com/free-vector/gradient-grainy-texture_23-2148981502.jpg?w=360",
]

extension String {
    static let loremText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

    func dummyLong(separator: String = " ") -> String {
        (0...10).map { _ in self }.joined(separator: separator)
    }

    func repeating(_ count: Int) -> String {
        (0...count).map { _ in self }.joined(separator: "")
    }
}
