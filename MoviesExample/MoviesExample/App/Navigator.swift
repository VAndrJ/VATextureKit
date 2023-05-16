//
//  Navigator.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKit

@MainActor
final class Navigator: Hashable, Equatable {
    nonisolated static func == (lhs: Navigator, rhs: Navigator) -> Bool {
        lhs.id == rhs.id
    }

    let id = UUID()
    let screenFactory: ScreenFactory
    let navigationController: NavigationController

    private weak var parent: Navigator?
    private var childNavigators: Set<AnyHashable> = []

    init(
        screenFactory: ScreenFactory,
        navigationController: NavigationController,
        initialRoute: NavigationRoute? = nil,
        parent: Navigator? = nil
    ) {
        self.screenFactory = screenFactory
        self.navigationController = navigationController
        self.parent = parent

        if let initialRoute {
            navigationController.setViewControllers(
                [screenFactory.create(screen: initialRoute.screen, navigator: self)],
                animated: false
            )
        }
    }

    init(
        screenFactory: ScreenFactory,
        navigationController: NavigationController,
        flow: Flow,
        parent: Navigator? = nil
    ) {
        self.screenFactory = screenFactory
        self.navigationController = navigationController
        self.parent = parent

        navigationController.setViewControllers(
            screenFactory.create(flow: flow, navigator: self),
            animated: false
        )
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func navigate(to route: NavigationRoute, animated: Bool = true) -> Responder? {
        switch route {
        case let .present(route):
            return present(route: route)
        default:
            let controller = screenFactory.create(screen: route.screen, navigator: self)
            navigationController.pushViewController(
                controller,
                animated: animated
            )
            return controller
        }
    }

    func closeAllAndPop(to controller: UIViewController?) {
        navigationController.presentedViewController?.dismiss(animated: false)
        if let controller {
            navigationController.popToViewController(controller, animated: false)
        }
    }

    func getChildNavigator(route: NavigationRoute? = nil) -> Navigator {
        let navigator = Navigator(
            screenFactory: ScreenFactory(),
            navigationController: NavigationController(),
            initialRoute: route
        )
        _ = childNavigators.insert(navigator)
        navigator.navigationController.onDismissed = { [weak self, weak navigator] in
            if let navigator {
                self?.childNavigators.remove(navigator)
            }
        }
        return navigator
    }

    func present(route: NavigationRoute) -> Responder? {
        let navigator = getChildNavigator(route: route)
        navigationController.pushViewController(navigator.navigationController, animated: true)
        return navigator
    }
}

extension Navigator: Responder {
    var nextEventResponder: Responder? {
        get { navigationController }
        set {} // swiftlint:disable:this unused_setter_value
    }

    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        return await nextEventResponder?.handle(event: event) ?? false
    }
}

enum NavigationRoute {
    case main
    case search
    case movie(ListMovieEntity)
    indirect case present(NavigationRoute)

    var screen: Screen {
        switch self {
        case .search:
            return .search
        case .main:
            return .main
        case let .movie(entity):
            return .movie(entity)
        case .present:
            assertionFailure("Handle in Navigator")
            return .main
        }
    }
}
