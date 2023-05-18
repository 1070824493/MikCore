//
//  Bundle.swift
//  LKCore
//
//  Created by m7 on 2021/11/22.
//

import Foundation

fileprivate class CurrentBundle {
    
    static func defaultBundle() -> Bundle? {
        guard let path = Bundle(for: self).path(forResource: "LKCoreBundle", ofType: "bundle") else {
            return nil
        }
        return Bundle(path: path)
    }
    
}

public extension LKNameSpace where Base: Bundle {
    
    static var `default`: Bundle { CurrentBundle.defaultBundle() ?? Bundle.main }
    
}


