//
//  ViewController.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import UIKit
import VATextureKit

protocol NavigationClosable: UIViewController {
    var isNotImportant: Bool { get }
}

class ViewController<Node: ASDisplayNode & Responder & ControllerNode>: VAViewController<Node>, NavigationClosable {
    let bag = DisposeBag()
    let isNotImportant: Bool

    private let shouldHideNavigationBar: Bool

    init(node: Node, shouldHideNavigationBar: Bool = true, isNotImportant: Bool = false, title: String? = nil) {
        self.shouldHideNavigationBar = shouldHideNavigationBar
        self.isNotImportant = isNotImportant

        super.init(node: node)

        self.title = title
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        contentNode.viewDidLoad(in: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(shouldHideNavigationBar, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        if contentNode.isVisible {
            navigationController?.viewControllers.removeAll(where: { ($0 as? NavigationClosable)?.isNotImportant == true && $0 !== self })
        }
    }
}

extension ViewController: Responder {
    var nextEventResponder: Responder? {
        get { contentNode }
        set {} // swiftlint:disable:this unused_setter_value
    }

    func handle(event: ResponderEvent) async -> Bool {
        logResponder(from: self, event: event)
        return await nextEventResponder?.handle(event: event) ?? false
    }
}
