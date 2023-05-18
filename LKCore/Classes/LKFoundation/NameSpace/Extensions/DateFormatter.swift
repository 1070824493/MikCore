//
//  DateFormatter.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/4.
//

import Foundation

public enum DateTransformType {
    
    case ISO8601Date
    
    public var locale: Locale { Locale(identifier: "en_US_POSIX") }
    
    public var timeZone: TimeZone? { TimeZone(identifier: "America/Chicago") }
    
    public var dateFormatter: String { return "yyyy-MM-dd'T'HH:mm:ss.SSSZ" }
    
}


public extension LKNameSpace where Base == DateFormatter {
    
    private static let dateFormatter: DateFormatter = DateFormatter()
    
    static func formatter(_ dateFormat: String) -> DateFormatter {
        func reset() {
            /// 重置，防止外部修改
            Self.dateFormatter.calendar = .current
            Self.dateFormatter.locale = Calendar.current.locale
            Self.dateFormatter.timeZone = Calendar.current.timeZone
            Self.dateFormatter.amSymbol = "AM"
            Self.dateFormatter.pmSymbol = "PM"
        }
        
        reset()
        Self.dateFormatter.dateFormat = dateFormat
        return Self.dateFormatter
    }
    
}
