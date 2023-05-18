//
//  Date.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/12.
//

import Foundation


public extension LKNameSpace where Base == Date {
    
    /// eg. 2021.4.25 -> Date().lk.dateOffset(year: 1, month: -1) -> 2022.3.25
    func dateOffset(year: Int = 0,
                    month: Int = 0,
                    day: Int = 0,
                    hour: Int = 0,
                    minute: Int = 0,
                    second: Int = 0) -> Date? {
        var offsetComponents = DateComponents()
        offsetComponents.year = year
        offsetComponents.month = month
        offsetComponents.day = day
        offsetComponents.hour = hour
        offsetComponents.minute = minute
        offsetComponents.second = second
        return Calendar.current.date(byAdding: offsetComponents, to: self.base)
    }
    
    /// 取时间戳
    /// - Parameters:
    ///   - dateString: 时间
    ///   - dateTransFormType: 转换类型，默认为ISO8601Date
    /// - Returns: 转换后的时间戳
    static func timeInterval(_ dateString: String?, dateTransFormType: DateTransformType = .ISO8601Date) -> TimeInterval? {
        guard let dateString = dateString else { return nil }
        let format = DateFormatter.lk.formatter(dateTransFormType.dateFormatter)
        format.locale = dateTransFormType.locale
        format.timeZone = dateTransFormType.timeZone
        return format.date(from: dateString)?.timeIntervalSince1970
    }
    
    /// 给定时间戳转对应格式的日期
    /// - Parameters:
    ///   - timestamp: 时间戳
    ///   - formatter: 时间格式
    /// - Returns: 转换后的日期
    static func dateString(_ timestamp: TimeInterval?, formatter: String) -> String? {
        guard let timestamp = timestamp else { return nil }
        let date = Date(timeIntervalSince1970: {
            if "\(Int(timestamp))".count > 10 { return timestamp / 1000 }
            return timestamp
        }())
        return DateFormatter.lk.formatter(formatter).string(from: date)
    }
    
    static func translateTime(timeInterval: String?, formatter: String = "MM/dd/yy") -> String? {
        guard let timeInterval = timeInterval else { return nil }
        return Self.dateString(TimeInterval(timeInterval), formatter: formatter)
    }
    
}

/// Copy right from 'CaoYu'
public extension LKNameSpace where Base == Date {
    
    /// 使时间精确到‘日’
    func exactDate() -> Date? {
        var dateComponent = Calendar.current.dateComponents([.year, .month, .day], from: self.base)
        dateComponent.hour = 0
        dateComponent.minute = 0
        dateComponent.second = 0
        return Calendar.current.date(from: dateComponent)
    }
    
    /// 判断是否是同日
    func isInSameDay(in calendar: Calendar = .current, date: Date) -> Bool {
        return calendar.isDate(self.base, equalTo: date, toGranularity: .day)
    }
    
    /// 判断是否是同月
    func isInSameMonth(in calendar: Calendar = .current, date: Date) -> Bool {
        return calendar.component(.month, from: self.base) == calendar.component(.month, from: date)
    }
    
    /// 一个月的第一天
    func startOfMonth(in calendar: Calendar = .current) -> Date {
        return calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self.base)))?.lk.startOfDay(in: calendar) ?? self.base
    }
    
    /// 一个月的最后一天
    func endOfMonth(in calendar: Calendar = .current) -> Date {
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.base.lk.startOfMonth(in: calendar))?.lk.endOfDay(in: calendar) ?? self.base
    }
    
    /// 一天的开始时间
    func startOfDay(in calendar: Calendar = .current) -> Date {
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self.base) ?? self.base
    }
    
    /// 一天的结束时间
    func endOfDay(in calendar: Calendar = .current) -> Date {
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self.base) ?? self.base
    }
    
}
