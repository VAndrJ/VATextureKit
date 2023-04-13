//
//  Shortcuts.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import UIKit

struct ResponderShortcutEvent: ResponderEvent {
    let shortcut: Shortcut
}

final class ShortcutsService {

    func addShortcuts() {
        UIApplication.shared.shortcutItems?.removeAll()
        UIApplication.shared.shortcutItems = [
            UIApplicationShortcutItem(type: .search),
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

    var title: String {
        switch self {
        case .search: return R.string.localizable.shortcut_search_title()
        }
    }
    var subtitle: String? {
        switch self {
        case .search: return R.string.localizable.shortcut_search_description()
        }
    }
    var icon: UIApplicationShortcutIcon {
        switch self {
        case .search: return UIApplicationShortcutIcon(type: .search)
        }
    }
}
