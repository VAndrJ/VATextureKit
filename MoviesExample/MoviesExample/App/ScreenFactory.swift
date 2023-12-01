//
//  ScreenFactory.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit
@_exported import Swiftional

enum Screen {
    case main
    case search
    case movie(ListMovieEntity)
    case actor(ListActorEntity)
}

enum Flow {
    case tabs
}

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
            let navC = NavigationController()
            navC.setViewControllers(
                [create(screen: .search, navigator: navigator)],
                animated: false
            )
            return [
                MainTabBarController(tabs: [
                    // (.main, navigator.getChildNavigator(route: .main).navigationController), // WIP
                    (.search, navC),
                ]),
            ]
        }
    }

    func assembleScreen(identity: NavigationIdentity, navigator: Navigator) -> (UIViewController & Responder)? {
        switch identity {
        case let identity as MovieDetailsNavigationIdentity:
            let controller = ViewController(
                node: MovieDetailsNode(viewModel: MovieDetailsViewModel(data: .init(
                    related: .init(
                        id: identity.id,
                        listMovieEntity: identity.details
                    ),
                    source: .init(
                        getMovie: remoteDataSource.getMovie(id:),
                        getRecommendations: remoteDataSource.getMovieRecommendations(id:),
                        getMovieActors: remoteDataSource.getMovieActors(id:)
                    ),
                    navigation: .init(
                        followMovie: { [weak navigator] in navigator?.navigate(to: .movie($0)) },
                        followActor: { [weak navigator] in navigator?.navigate(to: .actor($0)) }
                    )
                ))),
                shouldHideNavigationBar: false,
                isNotImportant: true,
                title: identity.details?.title
            ).withAnimatedTransitionEnabled()
            controller.navigationIdentity = identity
            return controller
        default:
            return nil
        }
    }

    func create(screen: Screen, navigator: Navigator) -> UIViewController & Responder {
        switch screen {
        case let .actor(entity):
            let controller = ViewController(node: TestNode(viewModel: ArtistViewModel()))
            return controller
        case let .movie(entity):
            return ViewController(
                node: MovieDetailsNode(viewModel: MovieDetailsViewModel(data: .init(
                    related: .init(
                        id: entity.id,
                        listMovieEntity: entity
                    ),
                    source: .init(
                        getMovie: remoteDataSource.getMovie(id:),
                        getRecommendations: remoteDataSource.getMovieRecommendations(id:),
                        getMovieActors: remoteDataSource.getMovieActors(id:)
                    ),
                    navigation: .init(
                        followMovie: { [weak navigator] in navigator?.navigate(to: .movie($0)) },
                        followActor: { [weak navigator] in navigator?.navigate(to: .actor($0)) }
                    )
                ))),
                shouldHideNavigationBar: false,
                isNotImportant: true,
                title: entity.title
            ).withAnimatedTransitionEnabled()
        case .main:
            return ViewController(
                node: MainNode(viewModel: MainViewModel(data: .init(
                    source: .init(),
                    navigation: .init()
                ))),
                title: R.string.localizable.home_screen_title()
            )
        case .search:
            return ViewController(
                node: SearchNode(viewModel: SearchViewModel(data: .init(
                    source: .init(
                        getTrendingMovies: remoteDataSource.getTrendingMovies,
                        getSearchMovies: remoteDataSource.getSearchMovies
                    ),
                    navigation: .init(
                        closeAllAndPopTo: { [weak navigator] in navigator?.closeAllAndPop(to: $0) },
                        followMovie: { [weak navigator] in navigator?.navigate(to: .movie($0)) }
                    )
                ))),
                title: R.string.localizable.search_screen_title()
            )
        }
    }
}

class TestNode: DisplayNode<ArtistViewModel> {

    override func configureTheme(_ theme: VATheme) {
        backgroundColor = theme.systemGreen
    }
}

class ArtistViewModel: EventViewModel {
}
