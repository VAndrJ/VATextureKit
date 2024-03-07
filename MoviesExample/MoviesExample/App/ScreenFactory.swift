//
//  ScreenFactory.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit
import VANavigator

final class ScreenFactory: @unchecked Sendable, NavigatorScreenFactory {
    let network = Network(networkLogger: DebugNetworkLogger())
    private(set) lazy var remoteDataSource = RemoteDataSource(
        network: network,
        endpointData: MoviesEndpontData(
            domain: Environment.mainURLString,
            apiKey: Environment.apiKey
        )
    )

    // swiftlint:disable:next function_body_length
    func assembleScreen(identity: NavigationIdentity, navigator: Navigator) -> UIViewController {
        switch identity {
        case let identity as MainTabsNavigationIdentity:
            MainTabBarController(controllers: identity.tabsIdentity
                .map { identity in
                    NavigationController(controller: assembleScreen(identity: identity, navigator: navigator).apply {
                        $0.navigationIdentity = identity
                    }).apply {
                        $0.navigationIdentity = NavNavigationIdentity(childIdentity: identity)
                    }
                }
            )
        case _ as SearchNavigationIdentity:
            ViewController(
                node: SearchNode(viewModel: .init(data: .init(
                    source: .init(
                        getTrendingMovies: remoteDataSource.getTrendingMovies,
                        getSearchMovies: remoteDataSource.getSearchMovies
                    ),
                    navigation: .init(
                        followMovie: navigator ?> {
                            $0.navigate(
                                destination: .identity(MovieDetailsNavigationIdentity(movie: $1)),
                                strategy: .popToExisting(),
                                fallback: .init(
                                    destination: .identity(MovieDetailsNavigationIdentity(movie: $1)),
                                    strategy: .push(),
                                    animated: true
                                )
                            )
                        }
                    )
                ))),
                title: R.string.localizable.search_screen_title()
            )
        case let identity as MovieDetailsNavigationIdentity:
            ViewController(
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
                        followMovie: navigator ?> {
                            $0.navigate(
                                destination: .identity(MovieDetailsNavigationIdentity(movie: $1)),
                                strategy: .popToExisting(),
                                fallback: .init(
                                    destination: .identity(MovieDetailsNavigationIdentity(movie: $1)),
                                    strategy: .push(),
                                    animated: true
                                )
                            )
                        },
                        followActor: navigator ?> {
                            $0.navigate(
                                destination: .identity(ActorDetailsNavigationIdentity(actor: $1)),
                                strategy: .present()
                            )
                        }
                    )
                ))),
                shouldHideNavigationBar: false,
                isNotImportant: true,
                title: identity.movie.title
            ).withAnimatedTransitionEnabled()
        case let identity as ActorDetailsNavigationIdentity:
            ViewController(node: ActorDetailsNode(viewModel: .init(actor: identity.actor)))
        case _ as HomeNavigationIdentity:
            ViewController(node: HomeNode(viewModel: .init(data: .init(
                source: .init(),
                navigation: .init()
            ))))
        default:
            fatalError("Not implemented")
        }
    }
}
