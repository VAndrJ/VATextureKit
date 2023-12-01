//
//  Responder.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

protocol ResponderEvent {}

protocol Responder: AnyObject {
    var nextEventResponder: Responder? { get set }

    @MainActor
    func handle(event: ResponderEvent) async -> Bool
}
