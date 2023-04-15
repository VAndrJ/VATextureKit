//
//  MoviesEndpontData.swift
//  MoviesExample
//
//  Created by VAndrJ on 15.04.2023.
//

import Foundation

struct MoviesEndpontData {
    let domain: String
    let apiKey: String

    func getRequest<T: Decodable>(
        path: NetworkPath,
        method: NetworkRequestMethod,
        pathComponents: [NetworkPath.Component]? = nil,
        query: [NetworkQuery.Key: String]? = nil,
        headers: [String: String] = [:],
        body: Data? = nil,
        cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad,
        timeout: TimeInterval = 30,
        parser: NetworkResponseParser,
        type: T.Type = T.self
    ) -> NetworkEndpointData<T>? {
        try? NetworkEndpointData(
            urlString: domain + path.rawValue,
            method: method,
            pathComponents: pathComponents.flatMap { $0.map(\.rawValue) },
            query: ["api_key": Environment.apiKey].merging(
                query.flatMap {
                    Dictionary(
                        $0.map { ($0.key.rawValue, $0.value) },
                        uniquingKeysWith: { $1 }
                    )
                } ?? [:], uniquingKeysWith: { $1 }
            ),
            headers: headers,
            body: body,
            cachePolicy: cachePolicy,
            timeout: timeout,
            parser: parser
        )
    }
}
