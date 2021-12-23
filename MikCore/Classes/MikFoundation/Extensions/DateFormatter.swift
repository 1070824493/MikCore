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


public extension MikNameSpace where Base == DateFormatter {
    
    private static let dateFormatter: DateFormatter = {
        let aDateFormatter = DateFormatter()
        aDateFormatter.amSymbol = "AM"
        aDateFormatter.pmSymbol = "PM"
        return aDateFormatter
    }()
    
    static func formatter(_ dateFormat: String) -> DateFormatter {        
        Self.dateFormatter.dateFormat = dateFormat
        return Self.dateFormatter
    }
    
}
