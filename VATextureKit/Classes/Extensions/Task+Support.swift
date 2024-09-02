//
//  Task+Support.swift
//  VATextureKit
//
//  Created by VAndrJ on 9/1/24.
//

import Foundation

extension Task where Success == Never, Failure == Never {

    public static func sleep(milliseconds: UInt64) async throws {
        if #available(iOS 16.0, *) {
            try await Task.sleep(for: .milliseconds(milliseconds), tolerance: .zero)
        } else {
            try await Task.sleep(nanoseconds: milliseconds * 1_000_000)
        }
    }

    public static func sleep(seconds: UInt64) async throws {
        if #available(iOS 16.0, *) {
            try await Task.sleep(for: .seconds(seconds), tolerance: .zero)
        } else {
            try await Task.sleep(nanoseconds: seconds * 1_000_000_000)
        }
    }
}
