//
//  VANetworkImageNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 13.04.2023.
//

import AsyncDisplayKit

open class VANetworkImageNode: ASNetworkImageNode {
    public struct DTO {
        let image: String?
        let contentMode: UIView.ContentMode?
        let size: CGSize?
        let cornerRadius: CGFloat?
        let cornerRoundingType: ASCornerRoundingType
        let cornerCurve: VACornerCurve?

        public init(
            image: String? = nil,
            contentMode: UIView.ContentMode? = nil,
            size: CGSize? = nil,
            cornerRadius: CGFloat? = nil,
            cornerRoundingType: ASCornerRoundingType = .defaultSlowCALayer,
            cornerCurve: VACornerCurve? = nil
        ) {
            self.image = image
            self.contentMode = contentMode
            self.size = size
            self.cornerRadius = cornerRadius
            self.cornerRoundingType = cornerRoundingType
            self.cornerCurve = cornerCurve
        }
    }

    private(set) var data: DTO!

    public convenience init(data: DTO) {

        self.init()

        self.data = data
        if let image = data.image {
            switch Self.parseImage(string: image) {
            case let .image(image):
                self.image = image
            case let .url(url):
                self.url = url
            }
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

    open override func didLoad() {
        super.didLoad()

        if let cornerCurve = data?.cornerCurve {
            self.cornerCurve = cornerCurve
        }
    }
}

public enum ImageSource: Equatable {
    case url(URL?)
    case image(UIImage?)

    public var image: UIImage? {
        switch self {
        case .url: return nil
        case let .image(image): return image
        }
    }
    public var url: URL? {
        switch self {
        case let .url(url): return url
        case .image: return nil
        }
    }
}

public extension VANetworkImageNode {

    static func parseImage(string: String?) -> ImageSource {
        if let string, !string.isEmpty {
            if string.hasPrefix("http"), let url = URL(string: string) {
                return .url(url)
            } else if string.hasPrefix("file"), let url = URL(string: string), let image = UIImage(contentsOfFile: url.path) {
                return .image(image)
            } else if let image = UIImage(contentsOfFile: string) {
                return .image(image)
            }
        }

        return .url(nil)
    }
}
