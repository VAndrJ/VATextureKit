//
//  MainTabBarController.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

final class MainTabBarController: VATabBarController {
    enum Tab {
        case home
        case search

        var title: String {
            switch self {
            case .home: L.tab_home()
            case .search: L.tab_search()
            }
        }
        var image: UIImage? {
            switch self {
            case .home: .init(systemName: "house")
            case .search: .init(systemName: "magnifyingglass")
            }
        }
    }

    let tabControllers: [Tab: any UIViewController & Responder]

    init(tabs: [(tab: Tab, controller: any UIViewController & Responder)]) {
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
}

// MARK: - convenience inits

extension MainTabBarController {

    convenience init(controllers: [any UIViewController & Responder]) {
        let tabs: [(tab: Tab, controller: any UIViewController & Responder)] = controllers.compactMap { controller in
            func getTabs(identity: (any NavigationIdentity)?) -> (tab: Tab, controller: any UIViewController & Responder)? {
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
