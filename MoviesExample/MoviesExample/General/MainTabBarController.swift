//
//  MainTabBarController.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

final class MainTabBarController: VATabBarController, Responder {
    enum Tab {
        case main
        case search

        var title: String {
            switch self {
            case .main: return "Home"
            case .search: return "Search"
            }
        }
        var image: UIImage? {
            switch self {
            case .main: return UIImage(systemName: "house")
            case .search: return UIImage(systemName: "magnifyingglass")
            }
        }
    }

    weak var nextEventResponder: Responder?

    private let tabs: [Tab]
    private let tabControllers: [Tab: UIViewController & Responder]

    init(tabs: [(tab: Tab, controller: UIViewController & Responder)]) {
        self.tabs = tabs.map(\.tab)
        self.tabControllers = Dictionary(tabs, uniquingKeysWith: { $1 })

        super.init(nibName: nil, bundle: nil)

        tabs.forEach { tab, controller in
            controller.configureTabBarItem(title: tab.title, image: tab.image)
        }
        setViewControllers(tabs.map(\.controller), animated: false)
    }

    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        switch event {
        case let event as ResponderShortcutEvent:
            navigationController?.popToViewController(self, animated: true)
            switch event.shortcut {
            case .search:
                selectedIndex = tabs.firstIndex(of: .search) ?? 0
            }
            return await tabControllers[.search]?.handle(event: event) ?? false
        default:
            return await nextEventResponder?.handle(event: event) ?? false
        }
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        tabBar.configureAppearance(theme: theme)
    }
}