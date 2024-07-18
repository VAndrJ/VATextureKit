//
//  ViewController.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import VATextureKitRx

protocol NavigationClosable: UIViewController {
    var isNotImportant: Bool { get }
}

class ViewController<Node: ASDisplayNode & Responder & ControllerNode>: VAViewController<Node>, NavigationClosable, Responder {
    let bag = DisposeBag()
    let isNotImportant: Bool

    private let shouldHideNavigationBar: Bool

    init(
        node: Node,
        shouldHideNavigationBar: Bool = true,
        isNotImportant: Bool = false,
        title: String? = nil
    ) {
        self.shouldHideNavigationBar = shouldHideNavigationBar
        self.isNotImportant = isNotImportant

        super.init(node: node)

        self.title = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentNode.viewDidLoad(in: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        contentNode.viewWillAppear(in: self, animated: animated)
        navigationController?.setNavigationBarHidden(shouldHideNavigationBar, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        contentNode.viewDidAppear(in: self, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        contentNode.viewWillDisappear(in: self, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        contentNode.viewDidDisappear(in: self, animated: animated)
    }
    
    // MARK: - Responder

    var nextEventResponder: (any Responder)? {
        get { contentNode }
        set { contentNode.nextEventResponder = newValue }
    }

    func handle(event: any ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)

        return await nextEventResponder?.handle(event: event) ?? false
    }
}
