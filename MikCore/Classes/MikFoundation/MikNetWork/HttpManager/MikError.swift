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
    /// 无效的'URL'
    case invalidURL

    /// 解析标准模型错误
    case deserializeNil

    /// 返回的数据格式与实际解析的规则不匹配(确认下是否调错方法)
    case responseFormatError

    /// 返回的错误data解析格式异常(错误数据非字典/字符串)
    case errorFormatError

    /// path路径中包含了请求参数
    case pathFormatError

    /// 其它错误
    case requestError(info: MikResponseErrorInfoModel?)
}

public extension MikError {
    var code: String? {

        switch self {
        case .requestError(let info):
            return [info?.code, info?.errorCode].compactMap { $0 }.first
        default: return nil
        }
    }


    /// 部分接口存在message与stackTrace同时存在的情况,且需要用stackTrace字段
    var stackTrace: String? {
        switch self {
        case .invalidURL:
            return "URL is not valid"
        case .requestError(let info):
            return [info?.stackTrace, info?.message, info?.errorMessage, info?.error].compactMap { $0 }.first
        default:
            return nil
        }
    }

    var message: String? {
        switch self {
        case .invalidURL:
            return "URL is not valid"
        case .requestError(let info):
            return [info?.message, info?.stackTrace, info?.errorMessage, info?.error].compactMap { $0 }.first
        default:
            return nil
        }
    }

    var data: Any? {
        switch self {
        case .requestError(let info):
            return info?.data
        default: return nil
        }
    }
}

/// 此模型揉和了目前已知的后台所有的单层错误字段, 等后台统一规范
public struct MikResponseErrorInfoModel: HandyJSON {
    public init() {}

    public init(message: String?) {
        self.message = message
    }

    public var timestamp: String?
    public var status: String?
    public var stackTrace: String?
    public var origin: String?
    public var error: String?
    public var errorCode: String?
    public var errorMessage: String?
    public var path: String?

    /// 标准返回字段
    public var code: String?
    public var message: String?
    public var data: Any?

    public var httpCode: Int?
}
