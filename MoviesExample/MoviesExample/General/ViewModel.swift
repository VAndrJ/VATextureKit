//
//  ViewModel.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

@MainActor
class ViewModel: NSObject, Responder {
    weak var nextEventResponder: Responder?

    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        return await nextEventResponder?.handle(event: event) ?? false
    }
}
