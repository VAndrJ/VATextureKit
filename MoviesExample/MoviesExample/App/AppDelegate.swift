//
//  AppDelegate.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import UIKit
import VATextureKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private var compositionRoot: CompositionRoot?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        compositionRoot = CompositionRoot(
            window: &window,
            application: application,
            launchOptions: launchOptions
        )

        return true
    }

    func application(
        _ application: UIApplication,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        guard let shortcut = Shortcut(rawValue: shortcutItem.type) else {
            completionHandler(false)
            return
        }

        Task {
            let result = await handle(event: ResponderShortcutEvent(shortcut: shortcut))
            completionHandler(result)
        }
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        compositionRoot?.application(app, open: url, options: options) ?? false
    }

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        .portrait
    }
}

extension AppDelegate: Responder {
    var nextEventResponder: Responder? {
        get { compositionRoot }
        set {} // swiftlint:disable:this unused_setter_value
    }

    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        if let nextEventResponder {
            return await nextEventResponder.handle(event: event)
        } else {
            try? await Task.sleep(milliseconds: 300)
            return await handle(event: event)
        }
    }
}
