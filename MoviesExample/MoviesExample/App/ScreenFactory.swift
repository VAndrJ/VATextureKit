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

    // swiftlint:disable function_body_length
    func assembleScreen(identity: NavigationIdentity, navigator: Navigator) -> (UIViewController & Responder)? {
        switch identity {
        case let identity as MainTabsNavigationIdentity:
            let controller = MainTabBarController(controllers: identity.tabsIdentity
                .compactMap { identity in
                    assembleScreen(identity: identity, navigator: navigator).map { ($0, identity) }
                }
                .map { controller, identity in
                    let controller = NavigationController(controller: controller)
                    controller.navigationIdentity = NavNavigationIdentity(childIdentity: identity)
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
                                destination: .identity(MovieDetailsNavigationIdentity(movie: $0)),
                                strategy: .pushOrPopToExisting()
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
                                destination: .identity(MovieDetailsNavigationIdentity(movie: $0)),
                                strategy: .pushOrPopToExisting()
                            )
                        },
                        followActor: { [weak navigator] in
                            navigator?.navigate(
                                destination: .identity(ActorDetailsNavigationIdentity(actor: $0)),
                                strategy: .present
                            )
                        }
                    )
                ))),
                shouldHideNavigationBar: false,
                isNotImportant: true,
                title: identity.movie.title
            ).withAnimatedTransitionEnabled()
            controller.navigationIdentity = identity
            return controller
        case let identity as ActorDetailsNavigationIdentity:
            let controller = ViewController(node: ActorDetailsNode(viewModel: ActorDetailsViewModel(actor: identity.actor)))
            controller.navigationIdentity = identity
            return controller
        case let identity as HomeNavigationIdentity:
            let controller = ViewController(node: HomeNode(viewModel: HomeViewModel(data: .init(
                source: .init(),
                navigation: .init()
            ))))
            controller.navigationIdentity = identity
            return controller
        default:
            assertionFailure("Not implemented")
            return nil
        }
    }
    // swiftlint:enable function_body_length

    func embedInNavigationControllerIfNeeded(controller: UIViewController) -> UIViewController {
        if let controller = controller.orNavigationController {
            return controller
        } else {
            let controller = NavigationController(controller: controller)
            controller.navigationIdentity = NavNavigationIdentity()
            return controller
        }
    }
}
