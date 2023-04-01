//
//  Environment.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 31.03.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import Foundation

enum Environment {
    enum TestType {
        enum Flow {
            case main
        }

        case ui(Flow)
        case unit
    }

    static var isTesting: Bool {
        let arguments = ProcessInfo.processInfo.arguments
        return arguments.contains("IS_TESTING") || arguments.contains("IS_UI_TESTING")
    }

    static var testType: TestType {
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("IS_UI_TESTING") {
            if arguments.contains("MAIN_FLOW") {
                return .ui(.main)
            } else {
                fatalError("implement")
            }
        } else {
            return .unit
        }
    }
}
