//
//  MainActorEscaped.swift
//  MoviesExample
//
//  Created by VAndrJ on 07.12.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import Foundation

struct MainActorEscaped<T>: @unchecked Sendable {
    let value: T

    init(value: @MainActor @escaping () -> T) {
        let value: () -> T = value

        self.value = value()
    }
}
