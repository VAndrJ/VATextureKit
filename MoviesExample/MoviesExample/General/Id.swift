//
//  Id.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

protocol Movie {}
protocol Genre {}
protocol Actor {}

public struct Id<Tag>: Codable, RawRepresentable, Equatable, Hashable, ExpressibleByIntegerLiteral, CustomStringConvertible, Sendable {
    public let rawValue: Int
    public var description: String { "\(rawValue)" }

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self.rawValue = value
    }
}
