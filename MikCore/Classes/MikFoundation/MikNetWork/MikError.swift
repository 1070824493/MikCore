//
//  MikError.swift
//  Demo
//
//  Created by gaowei on 2021/4/17.
//

import Foundation
import HandyJSON

public enum MikError: Error {
    
    /// 请求取消
    case cancel
    /// 其它错误
    case requestError(info: MikResponseErrorInfoModel?)
        
    public var code: Int {
        switch self {
        case .requestError(let info): return info?.code ?? 0
        default: return 0
        }
    }
    
    public var message: String {
        switch self {
        case .requestError(let info):
            if let message = info?.message, !message.isEmpty {
                return message
            }
            return info?.stackTrace ?? ""
        default: return ""
        }
    }
    
}

public struct MikResponseErrorInfoModel: HandyJSON {
    
    public init() {}
    
    public init(message: String?) {
        self.message = message
    }
    
    public var timestamp: String?
    public var status: String?
    public var stackTrace: String?
    public var origin: String?
    public var code: Int?
    
    // network error msg
    public var message: String?
    
}

