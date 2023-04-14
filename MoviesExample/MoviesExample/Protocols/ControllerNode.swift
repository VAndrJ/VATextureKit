//
//  ControllerNode.swift
//  MoviesExample
//
//  Created by VAndrJ on 12.04.2023.
//

import UIKit
import AsyncDisplayKit

@MainActor
protocol ControllerNode: ASDisplayNode {

    func viewDidLoad(in controller: UIViewController)
    func viewDidAppear(in controller: UIViewController, animated: Bool)
    func viewWillAppear(in controller: UIViewController, animated: Bool)
    func viewWillDisappear(in controller: UIViewController, animated: Bool)
    func viewDidDisappear(in controller: UIViewController, animated: Bool)
}
