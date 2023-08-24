//
//  VANetworkImageNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 13.04.2023.
//

import AsyncDisplayKit

/// `VANetworkImageNode` is a subclass of `ASNetworkImageNode` that adds support for custom corner rounding to the image displayed. It provides the ability to specify a corner rounding configuration and displays either a remote URL image or a locally stored image.
open class VANetworkImageNode: ASNetworkImageNode {
    /// The corner rounding configuration for the image node.
    public var corner: VACornerRoundingParameters {
        get { _corner }
        set {
            _corner = newValue
            updateCornerParameters()
        }
    }

    private var _corner: VACornerRoundingParameters!

    /// Initializes the `VANetworkImageNode` with optional parameters.
    ///
    /// - Parameters:
    ///   - image: The image URL or local image file path.
    ///   - size: The preferred size of the image node.
    ///   - contentMode: The content mode for displaying the image.
    ///   - corner: The corner rounding configuration for the image node.
    public convenience init(
        image: String? = nil,
        size: CGSize? = nil,
        contentMode: UIView.ContentMode? = nil,
        corner: VACornerRoundingParameters = .init()
    ) {
        self.init()

        self._corner = corner
        if let image {
            switch Self.parseImage(string: image) {
            case let .image(image):
                self.image = image
            case let .url(url):
                self.url = url
            }
        }
        if let size {
            self.style.preferredSize = size
        }
        if let contentMode {
            self.contentMode = contentMode
        }
    }

    open override func didLoad() {
        super.didLoad()

        updateCornerParameters()
    }

    open override func layout() {
        super.layout()

        if case let .proportional(percent) = corner.radius {
            cornerRadius = min(bounds.width, bounds.height) * percent / 200
        }
    }

    private func updateCornerParameters() {
        cornerCurve = corner.curve
        cornerRoundingType = corner.roundingType
        if case let .fixed(value) = corner.radius {
            cornerRadius = value
        }
    }
}

/// An enumeration defining the possible sources of an image: either a URL or a local UIImage.
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

    /// Parses the provided string to determine the source of the image.
    ///
    /// - Parameter string: The string to parse for image information.
    /// - Returns: An `ImageSource` enum value indicating whether the string corresponds to a URL or a local image.
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
