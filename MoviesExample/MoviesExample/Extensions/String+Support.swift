//
//  String+Support.swift
//  MoviesExample
//
//  Created by VAndrJ on 13.04.2023.
//

import Foundation

extension String {

    func getImagePath(width: Int) -> String {
        "https://image.tmdb.org/t/p/w\(width)\(self)"
    }
}
