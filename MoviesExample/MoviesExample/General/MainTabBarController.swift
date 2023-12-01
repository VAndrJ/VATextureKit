//
//  MainTabBarController.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

final class MainTabBarController: VATabBarController, Responder {
    enum Tab {
        case home
        case search

        var title: String {
            switch self {
            case .home: return "Home"
            case .search: return "Search"
            }
        }
        var image: UIImage? {
            switch self {
            case .home: return UIImage(systemName: "house")
            case .search: return UIImage(systemName: "magnifyingglass")
            }
        }
    }

    let tabs: [Tab]
    let tabControllers: [Tab: UIViewController & Responder]

    init(tabs: [(tab: Tab, controller: UIViewController & Responder)]) {
        self.tabs = tabs.map(\.tab)
        self.tabControllers = Dictionary(tabs, uniquingKeysWith: { $1 })

        super.init(nibName: nil, bundle: nil)

        tabs.forEach { tab, controller in
            controller.configureTabBarItem(title: tab.title, image: tab.image)
        }
        setViewControllers(tabs.map(\.controller), animated: false)
    }

    override func configureTheme(_ theme: VATheme) {
        super.configureTheme(theme)

        tabBar.configureAppearance(theme: theme)
    }

    // MARK: - Responder

    weak var nextEventResponder: Responder?

    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)

        return await nextEventResponder?.handle(event: event) ?? false
    }
}

// MARK: - convenience inits

extension MainTabBarController {

    convenience init(controllers: [UIViewController & Responder]) {
        let tabs: [(tab: Tab, controller: UIViewController & Responder)] = controllers.compactMap { controller in
            func getTabs(identity: NavigationIdentity?) -> (tab: Tab, controller: UIViewController & Responder)? {
                switch identity {
                case _ as SearchNavigationIdentity:
                    return (.search, controller)
                case _ as HomeNavigationIdentity:
                    return (.home, controller)
                case let identity as NavNavigationIdentity:
                    return getTabs(identity: identity.childIdentity)
                default:
                    assertionFailure("Not implemented")
                    return nil
                }
            }

            return getTabs(identity: controller.navigationIdentity)
        }

        self.init(tabs: tabs)
    }
}
