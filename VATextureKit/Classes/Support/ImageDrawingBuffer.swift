//
//  ImageDrawingBuffer.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 11.03.2024.
//

public final class ImageDrawingBuffer: NSObject {
    private var isDataCreated = false
    private var length: Int
    private(set) var mutableBytes: UnsafeMutableRawPointer

    public init(
        length: Int
    ) {
        self.length = length
        self.mutableBytes = malloc(length)

        super.init()
    }

    public func createDataProviderAndInvalidate() -> CGDataProvider? {
        isDataCreated = true

        return CGDataProvider(data: NSData(bytesNoCopy: mutableBytes, length: length) { bytes, _ in
            free(bytes)
        })
    }

    deinit {
        if !isDataCreated {
            free(mutableBytes)
        }
    }
}
