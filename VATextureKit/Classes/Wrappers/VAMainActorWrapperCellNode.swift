//
//  VAMainActorWrapperCellNode.swift
//  VATextureKit
//
//  Created by VAndrJ on 9/7/24.
//

#if compiler(>=6.0)
public import AsyncDisplayKit
#else
import AsyncDisplayKit
#endif

@dynamicMemberLookup
public final class VAMainActorWrapperCellNode<Child: ASDisplayNode>: VASimpleCellNode, @unchecked Sendable {
    let childGetter: @MainActor () -> Child

    @MainActor private(set) public lazy var child = childGetter()

    private var spec: ASLayoutSpec?

    public init(childGetter: @MainActor @escaping () -> Child) {
        self.childGetter = childGetter

        super.init()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        addSubnode(child)
        spec = child.wrapped()
        setNeedsLayout()
    }

    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        defer {
            spec?.isMutable = true
        }

        return spec ?? ASLayoutSpec()
    }

    @MainActor
    public subscript<T>(dynamicMember keyPath: KeyPath<Child, T>) -> T {
        return child[keyPath: keyPath]
    }

    @available(*, unavailable)
    public override func isFirstResponder() -> Bool {
        false
    }

    @available(*, unavailable)
    public override func becomeFirstResponder() -> Bool {
        false
    }

    @available(*, unavailable)
    public override func canBecomeFirstResponder() -> Bool {
        false
    }

    @available(*, unavailable)
    public override func resignFirstResponder() -> Bool {
        false
    }

    @available(*, unavailable)
    public override func canResignFirstResponder() -> Bool {
        false
    }
}
