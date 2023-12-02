//
//  NavigationIdentity+Movies.swift
//  MoviesExample
//
//  Created by VAndrJ on 01.12.2023.
//

import Foundation

public protocol TabsNavigationIdentity: NavigationIdentity {
    var tabsIdentity: [NavigationIdentity] { get }
}

public struct MainTabsNavigationIdentity: TabsNavigationIdentity {
    public let tabsIdentity: [NavigationIdentity]
    public var fallbackSource: NavigationIdentity?

    public func isEqual(to other: NavigationIdentity?) -> Bool {
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
    var childIdentity: NavigationIdentity?
    var fallbackSource: NavigationIdentity?

    func isEqual(to other: NavigationIdentity?) -> Bool {
        guard let other = other as? NavNavigationIdentity else {
            return false
        }

        return childIdentity?.isEqual(to: other.childIdentity) == true
    }
}

struct HomeNavigationIdentity: NavigationIdentity {
    var fallbackSource: NavigationIdentity?

    func isEqual(to other: NavigationIdentity?) -> Bool {
        guard other is HomeNavigationIdentity else {
            return false
        }

        return true
    }
}

struct SearchNavigationIdentity: NavigationIdentity {
    var fallbackSource: NavigationIdentity?

    func isEqual(to other: NavigationIdentity?) -> Bool {
        guard other is SearchNavigationIdentity else {
            return false
        }

        return true
    }
}

struct MovieDetailsNavigationIdentity: NavigationIdentity {
    var movie: ListMovieEntity
    var fallbackSource: NavigationIdentity? = SearchNavigationIdentity()

    func isEqual(to other: NavigationIdentity?) -> Bool {
        guard let other = other as? MovieDetailsNavigationIdentity else {
            return false
        }

        return movie.id == other.movie.id
    }
}

struct ActorDetailsNavigationIdentity: NavigationIdentity {
    var actor: ListActorEntity
    var fallbackSource: NavigationIdentity? = SearchNavigationIdentity()

    func isEqual(to other: NavigationIdentity?) -> Bool {
        guard let other = other as? ActorDetailsNavigationIdentity else {
            return false
        }

        return actor.id == other.actor.id
    }
}
