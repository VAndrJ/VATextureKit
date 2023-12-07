//
//  Shortcuts.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import UIKit

@MainActor
final class ShortcutsService {

    func addShortcuts() {
        UIApplication.shared.shortcutItems?.removeAll()
        UIApplication.shared.shortcutItems = [
            UIApplicationShortcutItem(type: .search),
            UIApplicationShortcutItem(type: .home),
        ]
    }
}

private extension UIApplicationShortcutItem {

    convenience init(type source: Shortcut) {
        self.init(
            type: source.rawValue,
            localizedTitle: source.title,
            localizedSubtitle: source.subtitle,
            icon: source.icon,
            userInfo: nil
        )
    }
}

enum Shortcut: String {
    case search = "com.vandrj.MoviesExample.search"
    case home = "com.vandrj.MoviesExample.home"

    var title: String {
        switch self {
        case .search: return R.string.localizable.shortcut_search_title()
        case .home: return R.string.localizable.shortcut_home_title()
        }
    }
    var subtitle: String? {
        switch self {
        case .search: return R.string.localizable.shortcut_search_description()
        case .home: return R.string.localizable.shortcut_home_description()
        }
    }
    var icon: UIApplicationShortcutIcon {
        switch self {
        case .search: return UIApplicationShortcutIcon(type: .search)
        case .home: return UIApplicationShortcutIcon(type: .home)
        }
    }
}
