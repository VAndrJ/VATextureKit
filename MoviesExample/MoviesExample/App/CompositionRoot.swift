//
//  CompositionRoot.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import UIKit
import VATextureKit
import PINCache
import PINRemoteImage
import VANavigator

@MainActor
final class CompositionRoot {
    private weak var window: UIWindow?
    private let navigator: Navigator
    private let shortcutService = ShortcutsService()

    init(
        window: inout UIWindow?,
        application: UIApplication,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        window = VAWindow(standardLightTheme: .moviesTheme)
        self.navigator = Navigator(
            window: window,
            screenFactory: ScreenFactory()
        )
        self.window = window

        func launch() {
            navigator.navigate(
                destination: .identity(MainTabsNavigationIdentity(tabsIdentity: [
                    SearchNavigationIdentity(),
                    HomeNavigationIdentity(),
                ])),
                strategy: .replaceWindowRoot()
            )
        }

        #if DEBUG && targetEnvironment(simulator)
        if Environment.isTesting {
            window?.rootViewController = UIViewController()
            window?.makeKeyAndVisible()
        } else {
            launch()
        }
        #else
        launch()
        #endif

        shortcutService.addShortcuts()
        configureCache()
    }

    func handleShortcut(item: Shortcut) -> Bool {
        switch item {
        case .search:
            navigator.navigate(
                destination: .identity(SearchNavigationIdentity()),
                strategy: .closeToExisting,
                event: ResponderOpenedFromShortcutEvent()
            )
        case .home:
            navigator.navigate(
                destination: .identity(HomeNavigationIdentity()),
                strategy: .closeToExisting,
                event: ResponderOpenedFromShortcutEvent()
            )
        }

        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        #if DEBUG
        print("source application = \(options[.sourceApplication] ?? "Unknown")")
        #endif

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }
        guard components.path == "movie" else {
            return false
        }
        guard let listMovieEntity = ListMovieEntity(queryItems: components.queryItems) else {
            return false
        }

        navigator.navigate(
            destination: .identity(MovieDetailsNavigationIdentity(movie: listMovieEntity)),
            strategy: .popToExisting(),
            fallback: .init(
                destination: .identity(MovieDetailsNavigationIdentity(movie: listMovieEntity)),
                strategy: .push(),
                animated: true
            ),
            event: ResponderOpenedFromURLEvent()
        )

        return true
    }

    private func configureCache() {
        if let cache = (ASPINRemoteImageDownloader.shared().sharedPINRemoteImageManager().cache as? PINCache)?.diskCache {
            cache.byteLimit = 500 * 1024 * 1024
        }
    }
}
