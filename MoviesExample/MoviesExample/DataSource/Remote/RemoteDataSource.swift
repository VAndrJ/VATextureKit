//
//  RemoteDataSource.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import RxSwift

final class RemoteDataSource {
    private let network: Network
    // TODO: - Protocol
    private let endpointData: MoviesEndpontData
    private let responseParser = NetworkResponseParser(
        dateDecodingStrategy: .secondsSince1970,
        keyDecodingStrategy: .convertFromSnakeCase
    )

    init(network: Network, endpointData: MoviesEndpontData) {
        self.endpointData = endpointData
        self.network = network
    }

    func getTrendingMovies() -> Observable<[ListMovieEntity]> {
        network
            .request(data: endpointData.getRequest(
                path: .trending,
                method: .GET,
                pathComponents: [.movie, .day],
                parser: responseParser
            ))
            .map(ListMovieEntity.from(response:))
            .asMainObservable()
    }

    func getSearchMovies(query: String) -> Observable<[ListMovieEntity]> {
        network
            .request(data: endpointData.getRequest(
                path: .search,
                method: .GET,
                pathComponents: [.movie],
                query: [.query: query],
                parser: responseParser
            ))
            .map(ListMovieEntity.from(response:))
            .asMainObservable()
    }

    func getMovie(id: Id<Movie>) -> Observable<MovieEntity> {
        network
            .request(data: endpointData.getRequest(
                path: .movie,
                method: .GET,
                pathComponents: [.convertible(id)],
                parser: responseParser
            ))
            .map(MovieEntity.init(response:))
            .asMainObservable()
    }

    func getMovieRecommendations(id: Id<Movie>) -> Observable<[ListMovieEntity]> {
        network
            .request(data: endpointData.getRequest(
                path: .movie,
                method: .GET,
                pathComponents: [.convertible(id), .recommendations],
                parser: responseParser
            ))
            .map(ListMovieEntity.from(response:))
            .asMainObservable()
    }

    func getMovieActors(id: Id<Movie>) -> Observable<[ListActorEntity]> {
        network
            .request(data: endpointData.getRequest(
                path: .movie,
                method: .GET,
                pathComponents: [.convertible(id), .credits],
                parser: responseParser
            ))
            .map(ListActorEntity.from(response:))
            .asMainObservable()
    }
}
