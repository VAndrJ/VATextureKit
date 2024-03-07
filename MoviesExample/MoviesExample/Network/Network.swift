//
//  Network.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

final class Network: Sendable {
    let coreRequest: @Sendable (_ request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>
    let networkLogger: NetworkLogger

    init(
        networkLogger: NetworkLogger,
        coreRequest: @escaping @Sendable (_ request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> = {
        URLSession.shared.rx.response(request: $0) }
    ) {
        self.networkLogger = networkLogger
        self.coreRequest = coreRequest

        URLSession.rx.shouldLogRequest = { _ in false }
    }

    func request<T: Decodable>(data: NetworkEndpointData<T>?) -> Observable<T> {
        guard let data else {
            return .error(NetworkError.emptyRequestData)
        }
        
        let requestDate = Date()

        return requestRaw(data: data)
            .map { try data.parser.parse(data: $0) }
            .do(onError: { [networkLogger] in
                networkLogger.log(
                    error: $0,
                    request: data.getRequest(),
                    date: requestDate
                )
            })
    }

    func requestRaw<T: Decodable>(data: NetworkEndpointData<T>?) -> Observable<Data> {
        guard let data else {
            return .error(NetworkError.emptyRequestData)
        }

        let requestDate = Date()
        let request = data.getRequest()
        return getData(response: coreRequest, request: { request })
            .do(
                onNext: { [networkLogger] in
                    networkLogger.log(
                        request: request,
                        response: $0.response,
                        data: $0.data,
                        date: requestDate
                    )
                },
                onError: { [networkLogger] in
                    networkLogger.log(
                        error: $0,
                        request: request,
                        date: requestDate
                    )
                }
            )
            .map { try self.handleResponse($0.response, $0.data) }
            .retryOnError()
            .retryOnNoConnection()
    }
    
    func getData(
        response: @escaping (URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>,
        request: @escaping () throws -> URLRequest
    ) -> Observable<(response: HTTPURLResponse, data: Data)> {
        Observable
            .deferred { .just(()) }
            .map { try request() }
            .flatMap { response($0) }
    }

    private func handleResponse(_ response: HTTPURLResponse, _ data: Data) throws -> Data {
        switch response.statusCode {
        case 200...299:
            return data
        case 400...499:
            throw NetworkError.server(try JSONDecoder().decode(ErrorFromServerResponseDTO.self, from: data))
        default:
            throw NetworkError.serverInternal
        }
    }
}
