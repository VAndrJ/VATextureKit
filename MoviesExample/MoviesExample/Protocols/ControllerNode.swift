//
//  ControllerNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import UIKit
import AsyncDisplayKit

protocol ControllerNode: ASDisplayNode {

    @MainActor
    func viewDidLoad(in controller: UIViewController)
    @MainActor
    func viewDidAppear(in controller: UIViewController, animated: Bool)
    @MainActor
    func viewWillAppear(in controller: UIViewController, animated: Bool)
    @MainActor
    func viewWillDisappear(in controller: UIViewController, animated: Bool)
    @MainActor
    func viewDidDisappear(in controller: UIViewController, animated: Bool)
}
