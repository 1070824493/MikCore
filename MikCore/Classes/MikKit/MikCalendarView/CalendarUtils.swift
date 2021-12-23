//
//  CalendarUtils.swift
//  MikMobile
//
//  Created by m7 on 2021/3/22.
//

import UIKit

/// 每页显示的行数
let kCalendarNumberOfRows = 6

/// 每周的天数
let kCalendarDayOfWeek = 7

/// Item间纵向间距
let kCalendarItemSpace: CGFloat = 4

///  Item的尺寸
let kCalendarItemSize: CGSize = CGSize(width: CGFloat(Int(UIScreen.main.bounds.width) / kCalendarDayOfWeek), height: min(CGFloat(Int(UIScreen.main.bounds.width) / kCalendarDayOfWeek), 52))

enum SelectedPosition {
    case unknow, start, middle, end, left, right
}

public typealias MikCalendarSelectedChangedCallback = (MikCalendarHandlerType) -> Void
public typealias MikDateRangeTuple = (fromDate: Date, toDate: Date)

public enum MikCalendarStyle {
    /// 点选
    case single(Date?)
    /// 点选
    case singleForClass(Date?)
    /// 范围选择
    case range(MikDateRangeTuple?)
    /// 特定范围点选
    case limit(MikDateRangeTuple, Date?)    
}

public enum MikCalendarSelectedType {
    /// 点选
    case single(Date?)
    /// 范围选择
    case range(MikDateRangeTuple?)
    /// 特定范围点选
    case limit(Date?)
}

public enum MikCalendarHandlerType {
    case single(Date?), range(MikDateRangeTuple?)
}

enum LimitPosition {
    case none, left, middle, right
    
    static func position(dateRange: MikDateRangeTuple?, date: Date?) -> LimitPosition {
        guard let fromDate = dateRange?.fromDate.mik.exactDate(), let toDate = dateRange?.toDate.mik.exactDate(), let date = date?.mik.exactDate() else { return .none }
                    
        switch (fromDate.compare(date), toDate.compare(date)) {
        case (.orderedSame, _): return .left
        case (_, .orderedSame): return .right
        case (.orderedAscending, .orderedDescending): return .middle
        default: return .none
        }
    }
}


extension Date {
        
    /// 默认显示时间范围
    static func defaultDateRange() -> MikDateRangeTuple {
        let startDate = Calendar.current.date(byAdding: .month, value: -12, to: Date()) ?? Date()
        let endDate = Calendar.current.date(byAdding: .month, value: 12, to: Date()) ?? Date()
        return (startDate, endDate)
    }
    
}
