//
//  Date+Support.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import Foundation

extension Date {
    var readableString: String { DateFormatter.readableDateFormatter.string(from: self) }
}
