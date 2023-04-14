//
//  RemoteDataSource.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import RxSwift

@MainActor
class RemoteDataSource {
    let network: Network

    init(network: Network) {
        self.network = network
    }

    func getTrendingMovies() -> Observable<[ListMovieEntity]> {
        network
            .request(data: try? NetworkEndpointData<ResultsWrapper<ListMovieResponseDTO>>(
                path: .trending,
                method: .GET,
                pathComponents: [.movie, .day],
                cachePolicy: .returnCacheDataElseLoad
            ))
            .map { $0.results.map(ListMovieEntity.init(response:)) }
            .asMainObservable()
    }

    func getSearchMovies(query: String) -> Observable<[ListMovieEntity]> {
        network
            .request(data: try? NetworkEndpointData<ResultsWrapper<ListMovieResponseDTO>>(
                path: .search,
                method: .GET,
                pathComponents: [.movie],
                query: [.query: query],
                cachePolicy: .returnCacheDataElseLoad
            ))
            .map { $0.results.map(ListMovieEntity.init(response:)) }
            .asMainObservable()
    }

    func getMovie(id: Id<Movie>) -> Observable<MovieEntity> {
        network
            .request(data: try? NetworkEndpointData<MovieResponseDTO>(
                path: .movie,
                method: .GET,
                pathComponents: [.convertible(id)],
                cachePolicy: .returnCacheDataElseLoad
            ))
            .map(MovieEntity.init(response:))
            .asMainObservable()
    }

    func getMovieRecommendations(id: Id<Movie>) -> Observable<[ListMovieEntity]> {
        network
            .request(data: try? NetworkEndpointData<ResultsWrapper<ListMovieResponseDTO>>(
                path: .movie,
                method: .GET,
                pathComponents: [.convertible(id), .recommendations],
                cachePolicy: .returnCacheDataElseLoad
            ))
            .map { $0.results.map(ListMovieEntity.init(response:)) }
            .asMainObservable()
    }

    func getMovieActors(id: Id<Movie>) -> Observable<[ListActorEntity]> {
        network
            .request(data: try? NetworkEndpointData<CastWrapper<CastResponseDTO>>(
                path: .movie,
                method: .GET,
                pathComponents: [.convertible(id), .credits],
                cachePolicy: .returnCacheDataElseLoad
            ))
            .map { $0.cast.compactMap(ListActorEntity.init(response:)) }
            .asMainObservable()
    }
}
