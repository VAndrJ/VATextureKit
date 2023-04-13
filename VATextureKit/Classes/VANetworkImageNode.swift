//
//  VANetworkImageNode.swift
//  VATextureKit
//
//  Created by VAndrJ on 13.04.2023.
//

import AsyncDisplayKit

open class VANetworkImageNode: ASNetworkImageNode {
    public struct DTO {
        let image: String?
        let contentMode: UIView.ContentMode?
        let size: CGSize?
        let cornerRadius: CGFloat?
        let cornerRoundingType: ASCornerRoundingType

        public init(
            image: String? = nil,
            contentMode: UIView.ContentMode? = nil,
            size: CGSize? = nil,
            cornerRadius: CGFloat? = nil,
            cornerRoundingType: ASCornerRoundingType = .defaultSlowCALayer
        ) {
            self.image = image
            self.contentMode = contentMode
            self.size = size
            self.cornerRadius = cornerRadius
            self.cornerRoundingType = cornerRoundingType
        }
    }

    public convenience init(data: DTO) {
        self.init()

        if let image = data.image {
            self.url = URL(string: image)
        }
        if let contentMode = data.contentMode {
            self.contentMode = contentMode
        }
        if let size = data.size {
            self.style.preferredSize = size
        }
        if let cornerRadius = data.cornerRadius {
            self.cornerRadius = cornerRadius
            self.cornerRoundingType = data.cornerRoundingType
        }
    }
}
