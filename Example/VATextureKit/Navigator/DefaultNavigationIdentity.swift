//
//  DefaultNavigationIdentity.swift
//  VATextureKit_Example
//
//  Created by VAndrJ on 07.03.2024.
//  Copyright © 2024 Volodymyr Andriienko. All rights reserved.
//

import Foundation

protocol DefaultNavigationIdentity: NavigationIdentity {}

extension DefaultNavigationIdentity {

    func isEqual(to other: NavigationIdentity?) -> Bool {
        other is Self
    }
}
