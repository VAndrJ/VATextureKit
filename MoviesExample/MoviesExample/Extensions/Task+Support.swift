//
//  Task+Support.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

extension Task where Success == Never, Failure == Never {

    public static func sleep(milliseconds: UInt64) async throws {
        if #available(iOS 16, *) {
            try await Task.sleep(until: .now + .milliseconds(milliseconds), clock: .continuous)
        } else {
            try await Task.sleep(nanoseconds: milliseconds * 1_000_000)
        }
    }
}
