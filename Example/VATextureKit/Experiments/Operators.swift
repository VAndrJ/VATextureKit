//
//  Operators.swift
//  VATextureKit_Example
//
//  Created by Volodymyr Andriienko on 26.07.2023.
//  Copyright © 2023 Volodymyr Andriienko. All rights reserved.
//

import Foundation

infix operator ?>> : ForwardComposition

public func ?>> <T: AnyObject>(_ obj: T?, _ block: @escaping (T) -> () -> Void) -> () -> Void {
    return { [weak obj] in
        guard let obj else { return }
        block(obj)()
    }
}

public func ?>> <T: AnyObject, U>(_ obj: T?, _ block: @escaping (T) -> (U) -> Void) -> (U) -> Void {
    return { [weak obj] in
        guard let obj else { return }
        block(obj)($0)
    }
}
