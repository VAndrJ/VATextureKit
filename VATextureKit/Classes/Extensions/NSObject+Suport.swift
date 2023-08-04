//
//  NSObject+Suport.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 02.08.2023.
//

import Foundation

public extension NSObject {

    func overrides(_ selector: Selector) -> Bool {
        var currentClass: AnyClass = type(of: self)
        guard let method: Method = class_getInstanceMethod(currentClass, selector) else {
            return false
        }

        while let superClass: AnyClass = class_getSuperclass(currentClass) {
            if class_getInstanceMethod(superClass, selector).map({ $0 != method }) ?? false {
                return true
            }

            currentClass = superClass
        }

        return false
    }
}
