//
//  NetworkEndpointData.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

struct NetworkEndpointData<T: Decodable> {
    let url: URL
    let baseUrl: URL
    let method: NetworkRequestMethod
    let pathComponents: [String]?
    let query: [String: String]?
    let headers: [String: String]
    let body: Data?
    let cachePolicy: URLRequest.CachePolicy
    let timeout: TimeInterval
    let parser: NetworkResponseParser

    init(
        urlString: String,
        method: NetworkRequestMethod,
        pathComponents: [String]? = nil,
        query: [String: String] = [:],
        headers: [String: String] = [:],
        body: Data? = nil,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeout: TimeInterval = 30,
        parser: NetworkResponseParser
    ) throws {
        guard let baseUrl = URL(string: urlString) else {
            throw NetworkError.incorrectEndpointBaseURL(string: urlString)
        }
        var base = baseUrl
        pathComponents?.forEach {
            base.appendPathComponent($0)
        }
        var urlComponents = URLComponents(url: base, resolvingAgainstBaseURL: false)
        if query.isNotEmpty {
            urlComponents?.queryItems = query.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        guard let url = urlComponents?.url else {
            throw NetworkError.incorrectEndpointURLComponents(
                path: String(describing: pathComponents),
                base: base.absoluteString
            )
        }

        self.url = url
        self.baseUrl = baseUrl
        self.method = method
        self.pathComponents = pathComponents
        self.query = query
        self.headers = headers
        self.body = body
        self.cachePolicy = cachePolicy
        self.timeout = timeout
        self.parser = parser
    }

    func getRequest() -> URLRequest {
        var request = URLRequest(
            url: url,
            cachePolicy: cachePolicy,
            timeoutInterval: timeout
        )
        switch method {
        case .GET:
            break
        case .POST, .PATCH, .DELETE:
            request.httpBody = body
        }
        request.httpMethod = method.rawValue
        return request
    }
}
