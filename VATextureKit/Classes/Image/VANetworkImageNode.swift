//
//  VANetworkImageNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 13.04.2023.
//

import AsyncDisplayKit

/// `VANetworkImageNode` is a subclass of `ASNetworkImageNode` that adds support for custom corner rounding to the image displayed. It provides the ability to specify a corner rounding configuration and displays either a remote URL image or a locally stored image.
open class VANetworkImageNode: ASNetworkImageNode, VACornerable {
    /// The corner rounding configuration for the node.
    public var corner: VACornerRoundingParameters {
        get { _corner }
        set {
            guard _corner != newValue else { return }

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
        corner: VACornerRoundingParameters = .default
    ) {
        self.init()

        self._corner = corner
        update(image: image)
        if let size {
            self.style.preferredSize = size
        }
        if let contentMode {
            self.contentMode = contentMode
        }
    }

    public func update(image: String?) {
        if let image {
            switch Self.parseImage(string: image) {
            case let .image(image):
                if self.image != image {
                    self.url = nil
                    self.image = image
                }
            case let .url(url):
                if self.url != url {
                    self.image = nil
                    self.url = url
                }
            }
        } else {
            self.image = nil
            self.url = nil
        }
    }

    open override func didLoad() {
        super.didLoad()

        updateCornerParameters()
    }

    open override func layout() {
        super.layout()

        updateCornerProportionalIfNeeded()
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
