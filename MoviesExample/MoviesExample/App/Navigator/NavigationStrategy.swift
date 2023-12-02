//
//  NavigationStrategy.swift
//  MoviesExample
//
//  Created by VAndrJ on 01.12.2023.
//

import Foundation

public enum NavigationStrategy: Equatable {
    case replaceWindowRoot(transition: CATransition? = nil)
    case push(alwaysEmbedded: Bool = true)
    case pushOrPopToExisting(alwaysEmbedded: Bool = true)
    case present
    case presentOrCloseToExisting
}
