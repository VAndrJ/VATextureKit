//
//  NetworkHeaders.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

struct NetworkHeaders {
    static let version = "1"

    enum Key {
        case authorization
        case contentType
        case contentDisposition
        case platform
        case version
        case accept
        case platformVersion

        var rawValue: String {
            switch self {
            case .accept: return "accept"
            case .version: return "version"
            case .platform: return "platform"
            case .authorization: return "Authorization"
            case .contentType: return "Content-Type"
            case .contentDisposition: return "Content-Disposition"
            case .platformVersion: return "platform-version"
            }
        }
    }

    enum Value {
        case applicationJson
        case multipartFormData
        case bearer(token: String)
        case platform
        case generic(Any)

        var rawValue: String {
            switch self {
            case .platform: return "iOS"
            case .applicationJson: return "application/json"
            case .multipartFormData: return "multipart/form-data"
            case let .bearer(token): return "Bearer \(token)"
            case let .generic(value): return "\(value)"
            }
        }
    }

    static let standard: [Key: Value] = [
        .contentType: .applicationJson,
        .platform: .platform,
        .version: .generic(Self.version)
    ]

    var values: [String: String]

    init(token: String) {
        self.init(additionalHeaders: [.authorization: .bearer(token: token)])
    }

    init(token: String, headers: [String: String]) {
        let headers = [Key.authorization.rawValue: Value.bearer(token: token).rawValue]
            .merging(headers, uniquingKeysWith: { $1 })

        self.init(additionalRawHeaders: headers)
    }

    init(additionalHeaders: [Key: Value]) {
        self.init(additionalRawHeaders: Dictionary(
            additionalHeaders.map { ($0.key.rawValue, $0.value.rawValue) },
            uniquingKeysWith: { $1 }
        ))
    }

    init(additionalRawHeaders: [String: String]) {
        self.values = Dictionary(
            Self.standard.map { ($0.key.rawValue, $0.value.rawValue) },
            uniquingKeysWith: { $1 }
        )
        .merging(additionalRawHeaders, uniquingKeysWith: { $1 })
    }
}
