//
//  NSAttributedString.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/9.
//

import Foundation


public extension MikNameSpace where Base: NSAttributedString {
    
    /// 依次拼接富文本
    /// - Parameter attributes: 被拼接的富文本集
    /// - Returns: 拼接后的富文本
    static func attribute(_ attributes: [(String, [NSAttributedString.Key: Any]?)]?) -> NSAttributedString? {
        guard let attributes = attributes, !attributes.isEmpty else { return nil }
        let mAttributeString = NSMutableAttributedString()
        attributes.forEach({
            mAttributeString.append(NSAttributedString(string: $0.0, attributes: $0.1))
        })
        return mAttributeString
    }
    
}
