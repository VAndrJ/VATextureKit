//
//  DateFormatter+Support.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

extension DateFormatter {
    static let readableDateFormatter = DateFormatter().apply {
        $0.dateFormat = "dd/MM/y HH:mm:ss.SSS"
    }
}
