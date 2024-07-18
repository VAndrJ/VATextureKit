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
    static let info = OSLog(subsystem: subsystem, category: "Info")
}

func logResponder(from: Any, event: any ResponderEvent) {
    #if DEBUG || targetEnvironment(simulator)
    os_log("%{public}@ %{public}@", log: OSLog.responderChain, type: .info, String(describing: from), String(describing: event))
    #endif
}

func log(info: Any) {
    #if DEBUG || targetEnvironment(simulator)
    os_log("%{public}@", log: OSLog.info, type: .info, String(describing: info))
    #endif
}
