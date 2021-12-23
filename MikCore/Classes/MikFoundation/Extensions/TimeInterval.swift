//
//  TimeInterval.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/12.
//
// "EEEE, MMM, d, yyyy h:mm a"
// ”星期几, 月份缩写, 日, 年, 时:分 am/pm“


import Foundation

public extension MikNameSpace where Base == TimeInterval {
    
    /// 时间格式化类型
    enum TimeFormatterSceneType {
        case chatConversation, chatMessage, notification
    }   
    
    /// 根据类型格式化时间
    /// - Parameter type: 格式化类型
    /// - Returns: 格式化结果
    func formatterValue(type: TimeFormatterSceneType) -> String {
        switch type {
        case .chatConversation: return self.chatConversationTimeFormat()
        case .chatMessage: return self.chatMesssageTimeFormat()
        case .notification: return self.chatMesssageTimeFormat()
        }
    }
    
}


fileprivate extension MikNameSpace where Base == TimeInterval {
    
    /// 聊天专用时间格式
    func chatMesssageTimeFormat() -> String {
        let date = Date(timeIntervalSince1970: self.base)
        
        guard Date().timeIntervalSince(date) > 0 else {
            // 异常情况，大于设备时间
            return DateFormatter.mik.formatter("h:mm a").string(from: date)
        }
        
        let currentCmps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let compareCmps = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
        if currentCmps.year == compareCmps.year { // 同年
            if currentCmps.month == compareCmps.month, currentCmps.day == compareCmps.day { // 今日
                return DateFormatter.mik.formatter("h:mm a").string(from: date)
            }else { // 非今日
                return DateFormatter.mik.formatter("MMM d, h:mm a").string(from: date)
            }
        }else {
            // 非同年
            return DateFormatter.mik.formatter("MMM, d, yyyy").string(from: date)
        }
    }
    
    /// 聊天专用时间格式
    func chatConversationTimeFormat() -> String {
        let date = Date(timeIntervalSince1970: self.base)
        
        guard Date().timeIntervalSince(date) > 0 else {
            // 异常情况，大于设备时间
            return DateFormatter.mik.formatter("h:mm a").string(from: date)
        }
        
        let currentCmps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let compareCmps = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
        if currentCmps.year == compareCmps.year { // 同年
            if currentCmps.month == compareCmps.month, currentCmps.day == compareCmps.day { // 今日
                return DateFormatter.mik.formatter("h:mm a").string(from: date)
            }else { // 非今日
                return DateFormatter.mik.formatter("MMM d").string(from: date)
            }
        }else { // 非同年
            return DateFormatter.mik.formatter("MMM, d, yyyy").string(from: date)
        }
    }
    
    
    /**
    /// 聊天专用时间格式
    func chatMesssageTimeFormat() -> String {
        let date = Date(timeIntervalSince1970: self.base)
        
        let currentCmps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        let compareCmps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                
        // 异常情况，设备时间大于发布时间
        if Date().timeIntervalSince(date) < 0 {
            return "Just now"
        }
        
        // "EEEE, MMM, d, yyyy h:mm a"
        
        if currentCmps.year == compareCmps.year {
            // 同年
            if currentCmps.month == compareCmps.month {
                // 同月
                if currentCmps.day == compareCmps.day {
                    // 同一天
                    if currentCmps.hour == compareCmps.hour, let currentMinute = currentCmps.minute, let compareMinute = compareCmps.minute, currentMinute - compareMinute < 3 {
                        // 三分钟之内
                        return "Just now"
                    }
                    return DateFormatter.mik.formatter("h:mm a").string(from: date)
                }else if let currentDay = currentCmps.day, let compareDay = compareCmps.day, currentDay - compareDay == 1 {
                    // 昨天
                    return "Yestoday " + DateFormatter.mik.formatter("h:mm a").string(from: date)
                }else if let currentDay = currentCmps.day, let compareDay = compareCmps.day, currentDay - compareDay < 7 {
                    // 相差大于1天，小于一周
                    return DateFormatter.mik.formatter("EEEE h:mm a").string(from: date)
                }else {
                    // 相差大于1周小于1月
                    return DateFormatter.mik.formatter("EEEE, MMM, d, h:mm a").string(from: date)
                }
            }else {
                // 非同月
                return DateFormatter.mik.formatter("EEEE, MMM, d").string(from: date)
            }
        }else {
            // 非同年
            return DateFormatter.mik.formatter("MMM, d, yyyy").string(from: date)
        }
    }
     */
    
}
