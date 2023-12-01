//
//  NavigationIdentity.swift
//  MoviesExample
//
//  Created by VAndrJ on 01.12.2023.
//

import Foundation

public protocol NavigationIdentity {

    func isEqual(to other: NavigationIdentity?) -> Bool
}
