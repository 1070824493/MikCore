//
//  UIScreen.swift
//  SellerMobile
//
//  Created by yu12 on 2021/4/12.
//

import UIKit

public extension LKNameSpace where Base == UIScreen {
    
    /// bounds
    static let bounds =  UIScreen.main.bounds
    
    /// bounds
    static let size: CGSize = UIScreen.main.bounds.size
    
    /// 宽度
    static let width: CGFloat = UIScreen.main.bounds.width
    
    /// 高度
    static let height: CGFloat = UIScreen.main.bounds.height
    
}
