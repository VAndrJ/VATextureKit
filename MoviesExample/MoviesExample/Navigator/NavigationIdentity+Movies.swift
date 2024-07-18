//
//  NavigationIdentity+Movies.swift
//  MoviesExample
//
//  Created by VAndrJ on 01.12.2023.
//

import Foundation

protocol DefaultNavigationIdentity: NavigationIdentity {}

extension DefaultNavigationIdentity {

    func isEqual(to other: (any NavigationIdentity)?) -> Bool {
        other is Self
    }
}

protocol TabsNavigationIdentity: NavigationIdentity {
    var tabsIdentity: [any NavigationIdentity] { get }
}

struct MainTabsNavigationIdentity: TabsNavigationIdentity {
    let tabsIdentity: [any NavigationIdentity]

    func isEqual(to other: (any NavigationIdentity)?) -> Bool {
        guard let other = other as? MainTabsNavigationIdentity else {
            return false
        }
        guard other.tabsIdentity.count == tabsIdentity.count else {
            return false
        }

        // swiftlint:disable for_where
        for pair in zip(tabsIdentity, other.tabsIdentity) {
            if !pair.0.isEqual(to: pair.1) {
                return false
            }
        }
        // swiftlint:enable for_where

        return true
    }
}

struct NavNavigationIdentity: NavigationIdentity {
    var childIdentity: (any NavigationIdentity)?

    func isEqual(to other: (any NavigationIdentity)?) -> Bool {
        guard let other = other as? NavNavigationIdentity else {
            return false
        }

        return childIdentity?.isEqual(to: other.childIdentity) == true
    }
}

struct HomeNavigationIdentity: DefaultNavigationIdentity {}

struct SearchNavigationIdentity: DefaultNavigationIdentity {}

struct MovieDetailsNavigationIdentity: NavigationIdentity {
    var movie: ListMovieEntity

    func isEqual(to other: (any NavigationIdentity)?) -> Bool {
        guard let other = other as? MovieDetailsNavigationIdentity else {
            return false
        }

        return movie.id == other.movie.id
    }
}

struct ActorDetailsNavigationIdentity: NavigationIdentity {
    var actor: ListActorEntity

    func isEqual(to other: (any NavigationIdentity)?) -> Bool {
        guard let other = other as? ActorDetailsNavigationIdentity else {
            return false
        }

        return actor.id == other.actor.id
    }
}
