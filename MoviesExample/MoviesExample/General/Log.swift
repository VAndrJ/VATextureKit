//
//  Log.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation
import os

extension OSLog {
    private static let subsystem = Bundle.main.bundleIdentifier! // swiftlint:disable:this force_unwrapping

    static let responderChain = OSLog(subsystem: subsystem, category: "ResponderChain")
}

func logResponder(from: Any, event: any ResponderEvent) {
    #if DEBUG || targetEnvironment(simulator)
    os_log("%{public}@ %{public}@", log: OSLog.responderChain, type: .info, String(describing: from), String(describing: event))
    #endif
}
