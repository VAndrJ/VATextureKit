//
//  NavigationStrategy.swift
//  MoviesExample
//
//  Created by VAndrJ on 01.12.2023.
//

import Foundation

public enum NavigationStrategy {
    case replaceWindowRoot
    case push
    case pushOrPopToExisting
    case present
    case presentOrCloseToExisting
}
