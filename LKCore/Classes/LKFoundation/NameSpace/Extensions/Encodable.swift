//
//  Encodable.swift
//  SellerMobile
//
//  Created by m7 on 2021/4/9.
//

import Foundation


extension LKNameSpace where Base: Encodable {
        
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self.base) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
}
