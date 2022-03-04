//
//  Array.swift
//  SellerMobile
//
//  Created by user on 2021/4/9.
//

import Foundation


public extension MikNameSpace where Base: Collection {
    
    /// Digital cross boundary processing
    subscript(safe index: Base.Index) -> Base.Element?{
       return self.base.indices.contains(index) ? self.base[index] : nil
    }
    
}

