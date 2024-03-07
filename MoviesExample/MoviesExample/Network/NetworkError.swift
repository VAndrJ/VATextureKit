//
//  NetworkError.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

enum NetworkError: Error, Equatable {
    case emptyResponseData
    case incorrectEndpointBaseURL(string: String)
    case incorrectEndpointURLComponents(path: String, base: String)
    case emptyRequestData
    case server(ErrorFromServerResponseDTO)
    case serverInternal
}

extension NetworkError: LocalizedError {
    var localizedDescription: String? {
        switch self {
        case .serverInternal: R.string.localizable.error_server_internal()
        case .emptyResponseData: R.string.localizable.error_response_empty_data()
        case .emptyRequestData: R.string.localizable.error_request_empty_data()
        case let .incorrectEndpointBaseURL(base): R.string.localizable.error_request_incorrect_base(base)
        case let .incorrectEndpointURLComponents(path, base): R.string.localizable.error_request_incorrect_components(path, base)
        case let .server(value): value.description
        }
    }
    var errorDescription: String? { localizedDescription }
}

struct ErrorFromServerResponseDTO: Codable, Equatable, Hashable, CustomStringConvertible {
    let statusMessage: String
    let statusCode: Int
    var description: String { statusMessage }
}
