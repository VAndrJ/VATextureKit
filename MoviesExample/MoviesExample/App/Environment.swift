//
//  Environment.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

// swiftlint:disable force_cast
enum Environment {
    static let mainURLString = Bundle.main.object(forInfoDictionaryKey: "MAIN_URL") as! String
    static let apiKey: String = {
        let string = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
        if string.allSatisfy({ $0 == "X" }) && !isTesting {
            fatalError("Replace API_KEY in Config.xcconfig file")
        } else {
            return string
        }
    }()

    enum TestType {
        enum Screen {
            case search
        }

        case ui(Screen)
        case unit
    }

    static var isTesting: Bool {
        let arguments = ProcessInfo.processInfo.arguments
        return arguments.contains("IS_TESTING") || arguments.contains("IS_UI_TESTING")
    }

    static var testType: TestType {
        let arguments = ProcessInfo.processInfo.arguments
        if arguments.contains("IS_UI_TESTING") {
            if arguments.contains("SEARCH_SCREEN") {
                return .ui(.search)
            } else {
                fatalError("implement")
            }
        } else {
            return .unit
        }
    }
}
