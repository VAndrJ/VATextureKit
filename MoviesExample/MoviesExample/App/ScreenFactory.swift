//
//  ScreenFactory.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit
import Swiftional

enum Screen {
    case main
    case search
    case movie(ListMovieEntity)
}

enum Flow {
    case tabs
}

@MainActor
final class ScreenFactory {
    let network = Network(networkLogger: DebugNetworkLogger())
    private(set) lazy var remoteDataSource = RemoteDataSource(
        network: network,
        endpointData: MoviesEndpontData(
            domain: Environment.mainURLString,
            apiKey: Environment.apiKey
        )
    )

    func create(flow: Flow, navigator: Navigator) -> [UIViewController & Responder] {
        switch flow {
        case .tabs:
            return [
                MainTabBarController(tabs: [
                    // (.main, create(screen: .main, navigator: navigator)), // WIP
                    (.search, create(screen: .search, navigator: navigator)),
                ]),
            ]
        }
    }

    func create(screen: Screen, navigator: Navigator) -> UIViewController & Responder {
        switch screen {
        case let .movie(entity):
            return ViewController(
                node: MovieDetailsNode(viewModel: .init(data: .init(
                    related: .init(listMovieEntity: entity),
                    source: .init(
                        getMovie: remoteDataSource.getMovie(id:),
                        getRecommendations: remoteDataSource.getMovieRecommendations(id:),
                        getMovieActors: remoteDataSource.getMovieActors(id:)
                    ),
                    navigation: .init(
                        followMovie: { [weak navigator] in navigator?.navigate(to: .movie($0)) }
                    )
                ))),
                shouldHideNavigationBar: false,
                isNotImportant: true,
                title: entity.title
            )
        case .main:
            fatalError("WIP")
        case .search:
            return ViewController(
                node: SearchNode(viewModel: SearchViewModel(data: .init(
                    source: .init(
                        getTrendingMovies: remoteDataSource.getTrendingMovies,
                        getSearchMovies: remoteDataSource.getSearchMovies
                    ),
                    navigation: .init(
                        followMovie: { [weak navigator] in navigator?.navigate(to: .movie($0)) }
                    )
                ))),
                title: R.string.localizable.search_screen_title()
            )
        }
    }
}
