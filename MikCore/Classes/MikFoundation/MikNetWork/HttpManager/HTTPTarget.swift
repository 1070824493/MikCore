//
//  TargetType.swift
//  MikCore
//
//  Created by ty on 2022/4/9.
//

import Alamofire
import Foundation
import HandyJSON

public protocol HTTPTarget {
    
    var baseURL: String { get }

    var rootPath: String? { get }

    /// 禁止在path中拼?参数
    var path: String { get }

    /// 相同path不同请求方式属于不同的API,需要新增枚举
    var method: HTTPMethod { get }

    var parameterEncoding: ParameterEncoding { get }

    var headers: HTTPHeaders? { get }


    //MARK: ---- Optional ----
    var retry: HTTPRetry { get }

    var validateCode: Range<Int> { get }

    var timeoutIntervalForRequest: TimeInterval? { get }

    var callbackQueue: DispatchQueue? { get }

    var emptyResponseCodes: Set<Int> { get }

//    var mockData: Data? { get }

}

public extension HTTPTarget {

    var rootPath : String? {
        return "/api"
    }

    /// 重试配置
    var retry: HTTPRetry {
        return .never
    }

    /// 请求http code验证
    var validateCode: Range<Int> {
        return 200..<300
    }

    /// 默认请求超时时间: 默认30S
    var timeoutIntervalForRequest: TimeInterval? {
        return nil
    }

    /// 默认response回调队列,nil代表默认的.main
    var callbackQueue: DispatchQueue? {
        return nil
    }

    /// 用于单元测试/接口不通时自定义测试
//    var mockData: Data? {
//        return nil
//    }


    /// 默认成功200,但是response为空的,也算成功
    var emptyResponseCodes: Set<Int> {
        return [200,204,205]
    }

}

public enum HTTPRetry: Equatable {
    case never
    case foreverUntilSuccess(TimeInterval)
    case severalTimes(times: Int, interval: TimeInterval)

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.severalTimes(let l), .severalTimes(let r)): return l == r
        default: return false
        }
    }
}
