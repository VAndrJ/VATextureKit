//
//  VAImageNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 05.04.2023.
//

import AsyncDisplayKit

open class VAImageNode: ASImageNode {
    public struct DTO {
        var image: UIImage?
        var tintColor: UIColor?
        var size: CGSize?
        var contentMode: UIView.ContentMode?
        var backgroundColor: UIColor?

        public init(
            image: UIImage? = nil,
            tintColor: UIColor? = nil,
            size: CGSize? = nil,
            contentMode: UIView.ContentMode? = nil,
            backgroundColor: UIColor? = nil
        ) {
            self.image = image
            self.tintColor = tintColor
            self.size = size
            self.contentMode = contentMode
            self.backgroundColor = backgroundColor
        }
    }

    private let data: DTO

    public init(data: DTO) {
        self.data = data

        super.init()

        if let contentMode = data.contentMode {
            self.contentMode = contentMode
        }
        if let image = data.image {
            self.image = image
        }
        if let tintColor = data.tintColor {
            self.tintColor = tintColor
        }
        if let size = data.size {
            self.style.preferredSize = size
        }
    }

    open override func didLoad() {
        super.didLoad()

        if let backgroundColor = data.backgroundColor {
            self.backgroundColor = backgroundColor
        }
    }
}
