//
//  VABaseTextNode.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 12.03.2024.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

#if AS_ENABLE_TEXTNODE2
open class _VATextNode: ASTextNode2, @unchecked Sendable {

    open override func didLoad() {
        super.didLoad()

        MainActor.assumeIsolated {
            self.viewDidLoad()
        }
    }

    @MainActor
    open func viewDidLoad() {}

    open override func layout() {
        super.layout()

        MainActor.assumeIsolated {
            viewDidLayoutSubviews()
        }
    }

    @MainActor
    open func viewDidLayoutSubviews() {}

    open override func willEnterHierarchy() {
        super.willEnterHierarchy()

        MainActor.assumeIsolated {
            viewWillEnterHierarchy()
        }
    }

    @MainActor
    open func viewWillEnterHierarchy() {}

    open override func didEnterHierarchy() {
        super.didEnterHierarchy()

        MainActor.assumeIsolated {
            viewDidEnterHierarchy()
        }
    }

    @MainActor
    open func viewDidEnterHierarchy() {}

    open override func didEnterPreloadState() {
        super.didEnterPreloadState()

        MainActor.assumeIsolated {
            viewDidEnterPreloadState()
        }
    }

    @MainActor
    open func viewDidEnterPreloadState() {}

    open override func didEnterDisplayState() {
        super.didEnterDisplayState()

        MainActor.assumeIsolated {
            viewDidEnterDisplayState()
        }
    }

    @MainActor
    open func viewDidEnterDisplayState() {}

    open override func didEnterVisibleState() {
        super.didEnterVisibleState()

        MainActor.assumeIsolated {
            viewDidEnterVisibleState()
        }
    }

    @MainActor
    open func viewDidEnterVisibleState() {}

    open override func didExitVisibleState() {
        super.didExitVisibleState()

        MainActor.assumeIsolated {
            viewDidExitVisibleState()
        }
    }

    @MainActor
    open func viewDidExitVisibleState() {}

    open override func didExitDisplayState() {
        super.didExitDisplayState()

        MainActor.assumeIsolated {
            viewDidExitDisplayState()
        }
    }

    @MainActor
    open func viewDidExitDisplayState() {}

    open override func didExitPreloadState() {
        super.didExitPreloadState()

        MainActor.assumeIsolated {
            viewDidExitPreloadState()
        }
    }

    @MainActor
    open func viewDidExitPreloadState() {}

    open override func didExitHierarchy() {
        super.didExitHierarchy()

        MainActor.assumeIsolated {
            viewDidExitHierarchy()
        }
    }

    @MainActor
    open func viewDidExitHierarchy() {}

    open override func animateLayoutTransition(_ context: any ASContextTransitioning) {
        let sendableContext = SendableASContextTransitioning(context: context)
        MainActor.assumeIsolated {
            viewDidAnimateLayoutTransition(sendableContext)
        }
    }

    @MainActor
    open func viewDidAnimateLayoutTransition(_ context: any ASContextTransitioning) {}
}

#else
open class _VATextNode: ASTextNode, @unchecked Sendable {

    open override func didLoad() {
        super.didLoad()

        MainActor.assumeIsolated {
            self.viewDidLoad()
        }
    }

    @MainActor
    open func viewDidLoad() {}

    open override func layout() {
        super.layout()

        MainActor.assumeIsolated {
            viewDidLayoutSubviews()
        }
    }

    @MainActor
    open func viewDidLayoutSubviews() {}

    open override func willEnterHierarchy() {
        super.willEnterHierarchy()

        MainActor.assumeIsolated {
            viewWillEnterHierarchy()
        }
    }

    @MainActor
    open func viewWillEnterHierarchy() {}

    open override func didEnterHierarchy() {
        super.didEnterHierarchy()

        MainActor.assumeIsolated {
            viewDidEnterHierarchy()
        }
    }

    @MainActor
    open func viewDidEnterHierarchy() {}

    open override func didEnterPreloadState() {
        super.didEnterPreloadState()

        MainActor.assumeIsolated {
            viewDidEnterPreloadState()
        }
    }

    @MainActor
    open func viewDidEnterPreloadState() {}

    open override func didEnterDisplayState() {
        super.didEnterDisplayState()

        MainActor.assumeIsolated {
            viewDidEnterDisplayState()
        }
    }

    @MainActor
    open func viewDidEnterDisplayState() {}

    open override func didEnterVisibleState() {
        super.didEnterVisibleState()

        MainActor.assumeIsolated {
            viewDidEnterVisibleState()
        }
    }

    @MainActor
    open func viewDidEnterVisibleState() {}

    open override func didExitVisibleState() {
        super.didExitVisibleState()

        MainActor.assumeIsolated {
            viewDidExitVisibleState()
        }
    }

    @MainActor
    open func viewDidExitVisibleState() {}

    open override func didExitDisplayState() {
        super.didExitDisplayState()

        MainActor.assumeIsolated {
            viewDidExitDisplayState()
        }
    }

    @MainActor
    open func viewDidExitDisplayState() {}

    open override func didExitPreloadState() {
        super.didExitPreloadState()

        MainActor.assumeIsolated {
            viewDidExitPreloadState()
        }
    }

    @MainActor
    open func viewDidExitPreloadState() {}

    open override func didExitHierarchy() {
        super.didExitHierarchy()

        MainActor.assumeIsolated {
            viewDidExitHierarchy()
        }
    }

    @MainActor
    open func viewDidExitHierarchy() {}

    open override func animateLayoutTransition(_ context: any ASContextTransitioning) {
        let sendableContext = SendableASContextTransitioning(context: context)
        MainActor.assumeIsolated {
            viewDidAnimateLayoutTransition(sendableContext)
        }
    }

    @MainActor
    open func viewDidAnimateLayoutTransition(_ context: any ASContextTransitioning) {}
}
#endif

open class VABaseTextNode: _VATextNode, VAThemeObserver, VAContentSizeObserver {
    /// The currently active theme obtained from the app's context.
    public var theme: VATheme { appContext.themeManager.theme }

    private(set) var shouldConfigureTheme = true
    private(set) var isObservingChanges = false

    open override func viewDidLoad() {
        super.viewDidLoad()

        if overrides(#selector(configureTheme(_:))) {
            appContext.themeManager.addThemeObserver(self)
            appContext.contentSizeManager.addContentSizeObserver(self)
            isObservingChanges = true
        }
    }

    open override func viewDidEnterDisplayState() {
        super.viewDidEnterDisplayState()

        if shouldConfigureTheme {
            configureTheme(theme)
            shouldConfigureTheme = false
        }
    }

    @objc open func configureTheme(_ theme: VATheme) {}

    public func themeDidChanged(to newTheme: VATheme) {
        if isInDisplayState {
            configureTheme(newTheme)
        } else {
            shouldConfigureTheme = true
        }
    }

    public func contentSizeDidChanged(to newValue: UIContentSizeCategory) {
        if isInDisplayState {
            configureTheme(theme)
        } else {
            shouldConfigureTheme = true
        }
    }

    deinit {
        if isObservingChanges {
            appContext.themeManager.removeThemeObserver(self)
            appContext.contentSizeManager.removeContentSizeObserver(self)
        }
    }
}
