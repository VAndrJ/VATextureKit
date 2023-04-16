//
//  String+Support.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import Foundation

extension String {
    var ns: NSString { self as NSString }

    func getImagePath(width: Int) -> String {
        if ns.pathComponents.count != 2 {
            return self
        } else {
            return "https://image.tmdb.org/t/p/w\(width)\(self)"
        }
    }
}
