//
//  ProcessInfo+Support.swift
//  VATextureKit
//
//  Created by VAndrJ on 25.05.2024.
//

import Foundation

public extension ProcessInfo {
    static var isRunningForPreviews: Bool {
        #if DEBUG
        return processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
        return false
        #endif
    }
}
