//
//  NetworkPath.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

enum NetworkPath: String {
    case search = "/search"
    case movie = "/movie"
    case trending = "/trending"

    enum Component {
        case movie
        case day
        case recommendations
        case credits
        case convertible(CustomStringConvertible)

        var rawValue: String {
            switch self {
            case let .convertible(value): return value.description
            default: return "\(self)"
            }
        }
    }
}
