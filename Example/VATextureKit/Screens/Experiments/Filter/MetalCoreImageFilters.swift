//
//  MetalCoreImageFilters.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 28.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import Foundation
import MetalKit

final class MetalDropPixelsFilter: CIFilter {
    private let kernel: CIColorKernel

    override init() {
        kernel = try! getColorKernel(name: "dropPixels") // swiftlint:disable:this force_try

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func outputImage(image: UIImage?) -> UIImage? {
        guard let ciImage = (image?.ciImage ?? image?.cgImage.map { CIImage(cgImage: $0) }) else {
            return nil
        }

        return kernel.apply(
            extent: ciImage.extent,
            arguments: [ciImage, Float.random(in: 0...255)]
        ).map { UIImage(ciImage: $0) }
    }
}

private func getColorKernel(name: String) throws -> CIColorKernel {
    guard let url = Bundle.main.url(forResource: "default", withExtension: "metallib") else {
        throw NSError(domain: "metallib", code: -1)
    }

    let data = try Data(contentsOf: url)

    return try CIColorKernel(functionName: name, fromMetalLibraryData: data)
}
