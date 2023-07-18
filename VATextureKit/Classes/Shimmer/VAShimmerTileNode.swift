//
//  VAShimmerTileNode.swift
//  VATextureKit
//
//  Created by VAndrJ on 19.07.2023.
//

import AsyncDisplayKit

public final class VAShimmerTileNode: VADisplayNode {
    struct DTO {
        var backgroundColor: UIColor = .gray
        // Rounded on nil
        var cornerRadius: CGFloat? = 0.0
    }

    let data: DTO

    init(data: DTO) {
        self.data = data

        super.init()

        if let cornerRadius = data.cornerRadius {
            self.cornerRadius = cornerRadius
        }
    }

    public override func layout() {
        super.layout()

        if data.cornerRadius == nil {
            self.cornerRadius = min(bounds.width, bounds.height) / 2
        }
    }

    public override func didLoad() {
        super.didLoad()

        backgroundColor = data.backgroundColor
    }
}
