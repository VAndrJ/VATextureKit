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
            screenFactory: ScreenFactory(),
            navigationController: NavigationController(),
            flow: .tabs
        )
        self.window = window

        func launch() {
            window?.rootViewController = navigator.navigationController
            window?.makeKeyAndVisible()
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
