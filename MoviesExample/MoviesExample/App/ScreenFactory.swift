//
//  ScreenFactory.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit
@_exported import Swiftional

final class ScreenFactory {
    let network = Network(networkLogger: DebugNetworkLogger())
    private(set) lazy var remoteDataSource = RemoteDataSource(
        network: network,
        endpointData: MoviesEndpontData(
            domain: Environment.mainURLString,
            apiKey: Environment.apiKey
        )
    )

    func assembleScreen(identity: NavigationIdentity, navigator: Navigator) -> (UIViewController & Responder)? {
        switch identity {
        case let identity as MainTabsNavigationIdentity:
            let controller = MainTabBarController(controllers: identity.tabsIdentity
                .compactMap {
                    assembleScreen(identity: $0, navigator: navigator)
                }
                .map {
                    let controller = NavigationController(controller: $0)
                    controller.navigationIdentity = NavNavigationIdentity(childIdentity: $0.navigationIdentity)
                    return controller
                }
            )
            controller.navigationIdentity = identity
            return controller
        case let identity as SearchNavigationIdentity:
            let controller = ViewController(
                node: SearchNode(viewModel: SearchViewModel(data: .init(
                    source: .init(
                        getTrendingMovies: remoteDataSource.getTrendingMovies,
                        getSearchMovies: remoteDataSource.getSearchMovies
                    ),
                    navigation: .init(
                        followMovie: { [weak navigator] in
                            navigator?.navigate(
                                destination: MovieDetailsNavigationIdentity(movie: $0),
                                strategy: .pushOrPopToExisting
                            )
                        }
                    )
                ))),
                title: R.string.localizable.search_screen_title()
            )
            controller.navigationIdentity = identity
            return controller
        case let identity as MovieDetailsNavigationIdentity:
            let controller = ViewController(
                node: MovieDetailsNode(viewModel: MovieDetailsViewModel(data: .init(
                    related: .init(
                        listMovieEntity: identity.movie
                    ),
                    source: .init(
                        getMovie: remoteDataSource.getMovie(id:),
                        getRecommendations: remoteDataSource.getMovieRecommendations(id:),
                        getMovieActors: remoteDataSource.getMovieActors(id:)
                    ),
                    navigation: .init(
                        followMovie: { [weak navigator] in
                            navigator?.navigate(
                                destination: MovieDetailsNavigationIdentity(movie: $0),
                                strategy: .pushOrPopToExisting
                            )
                        },
                        followActor: { [weak navigator] _ in
                            assertionFailure("Not implemented")
                            return nil
                        }
                    )
                ))),
                shouldHideNavigationBar: false,
                isNotImportant: true,
                title: identity.movie.title
            ).withAnimatedTransitionEnabled()
            controller.navigationIdentity = identity
            return controller
        default:
            assertionFailure("Not implemented")
            return nil
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
