//
//  LKNameSpace.swift
//  EyeShield
//
//  Created by m7 on 2021/2/25.
//

import Foundation


public struct LKNameSpace<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
    
}


public protocol LKNameSpaceCompatible {
    
    associatedtype LKNameSpaceBase
    
    static var lk: LKNameSpace<LKNameSpaceBase>.Type { get }
    
    var lk: LKNameSpace<LKNameSpaceBase> { get }
    
}

public extension LKNameSpaceCompatible {
    
    static var lk: LKNameSpace<Self>.Type { LKNameSpace<Self>.self }
    
    var lk: LKNameSpace<Self> { LKNameSpace<Self>(self) }
    
}

extension NSObject: LKNameSpaceCompatible {}

extension String: LKNameSpaceCompatible {}

extension Date: LKNameSpaceCompatible {}

extension TimeInterval: LKNameSpaceCompatible {}

extension Array : LKNameSpaceCompatible{}

extension Calendar : LKNameSpaceCompatible {}
