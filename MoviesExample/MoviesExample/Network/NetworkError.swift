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
    case server500
}

extension NetworkError: LocalizedError {

    var localizedDescription: String? {
        return String(describing: self)
//        switch self {
//        case .server500:
//            return R.string.localizable.network_general_error()
//        case .emptyResponseData:
//            return R.string.localizable.network_empty_response_data_error()
//        case .emptyRequestData:
//            return R.string.localizable.network_empty_request_data_error()
//        case let .incorrectEndpointBaseURL(string):
//            return R.string.localizable.network_incorrect_base_url_error(string)
//        case let .incorrectEndpointURLComponents(path, query, components):
//            return R.string.localizable.network_incorrect_url_components_error(path, query, components)
//        case let .server(value):
//            return value.description
//        }
    }

    var errorDescription: String? { localizedDescription }
}

struct ErrorFromServerResponseDTO: Codable, Equatable, Hashable, CustomStringConvertible {
    let statusMessage: String
    let statusCode: Int
    var description: String { statusMessage }
}
