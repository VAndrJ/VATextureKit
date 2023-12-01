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
                destination: MainTabsNavigationIdentity(tabsIdentity: [
                    SearchNavigationIdentity(),
                ]),
                strategy: .replaceWindowRoot
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
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        print("source application = \(options[.sourceApplication] ?? "Unknown")")

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL or album path missing")
            return false
        }
        guard components.path == "movie" else {
            return false
        }
        // swiftlint:disable indentation_width
        guard let queryItems = components.queryItems,
              let item = queryItems.first(where: { $0.name == "id" }),
              let id = item.value.flatMap({ Int($0).flatMap { Id<Movie>(rawValue: $0) } }),
              let title = queryItems.first(where: { $0.name == "title" })?.value,
              let year = queryItems.first(where: { $0.name == "year" })?.value
        else {
            return false
        }
        // swiftlint:enable indentation_width
        navigator.navigate(
            destination: MovieDetailsNavigationIdentity(movie: ListMovieEntity(
                id: id,
                title: title,
                overview: "",
                rating: 0,
                year: year
            )),
            strategy: .pushOrPopToExisting,
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

extension CompositionRoot: Responder {
    var nextEventResponder: Responder? {
        get { navigator }
        set {} // swiftlint:disable:this unused_setter_value
    }

    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        return await nextEventResponder?.handle(event: event) ?? false
    }
}
