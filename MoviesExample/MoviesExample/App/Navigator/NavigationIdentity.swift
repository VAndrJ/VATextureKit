//
//  NavigationIdentity.swift
//  MoviesExample
//
//  Created by VAndrJ on 01.12.2023.
//

import Foundation

public protocol NavigationIdentity {
    var fallbackSource: NavigationIdentity? { get set }

    func isEqual(to other: NavigationIdentity?) -> Bool
}
