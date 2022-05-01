//
//  MikNameSpace.swift
//  EyeShield
//
//  Created by m7 on 2021/2/25.
//

import Foundation


public struct MikNameSpace<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
    
}

public extension MikNameSpace {
    static func className() -> String {
        return String(describing: Base.self)
    }
}


public protocol MikNameSpaceCompatible {
    
    associatedtype MikNameSpaceBase
    
    static var mik: MikNameSpace<MikNameSpaceBase>.Type { get }
    
    var mik: MikNameSpace<MikNameSpaceBase> { get }
    
}

public extension MikNameSpaceCompatible {
    
    static var mik: MikNameSpace<Self>.Type { MikNameSpace<Self>.self }
    
    var mik: MikNameSpace<Self> { MikNameSpace<Self>(self) }
    
}

extension NSObject: MikNameSpaceCompatible {}

extension String: MikNameSpaceCompatible {}

extension Date: MikNameSpaceCompatible {}

extension TimeInterval: MikNameSpaceCompatible {}

extension Array : MikNameSpaceCompatible{}

extension Calendar : MikNameSpaceCompatible {}
