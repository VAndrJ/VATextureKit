//
//  VASimpleDisplayNode.swift
//  VATextureKit
//
//  Created by VAndrJ on 8/31/24.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

open class VASimpleDisplayNode: ASDisplayNode, @unchecked Sendable {

    public convenience init(viewGetter: @MainActor @escaping () -> UIView) {
        self.init {
            MainActor.assumeIsolated {
                viewGetter()
            }
        }
    }

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
