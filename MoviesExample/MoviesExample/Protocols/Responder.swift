//
//  Responder.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

struct ResponderDismissEvent: ResponderEvent {}

protocol ResponderEvent {}

@MainActor
protocol Responder: AnyObject {
    var nextEventResponder: Responder? { get set }

    func handle(event: ResponderEvent) async -> Bool
}
