//
//  HTTPRequestConfig.swift
//  MikCore
//
//  Created by ty on 2021/10/23.
//

import Alamofire
import Foundation
import UIKit
import RxSwift


public typealias Param = [String: Any]

private func +=(l: inout Param, r: Param) {
    for (k, v) in r {
        l[k] = v
    }
}

public enum RequestEncoding {
    case url // 对应Alamofire的url encoding, 代表： GET 或 POST表单上传
    case json // 对应Alamofire的json encoding, 代表： POST 传JSON
}

public struct HTTPUIConfig {
    

    public var showHUDConifgure: MikToast.HUDConifgure?
    
    //是否需要处理错误,默认处理, Toast提示/自定义
    public var needHandleError: Bool = true
    
    public init(showHUDConifgure: MikToast.HUDConifgure?,
                needHandleError: Bool = true) {
        
        self.showHUDConifgure = showHUDConifgure
        self.needHandleError = needHandleError
    }
}

public class HTTPRequestConfig {
    
    //MARK: ---- 请求可配置的参数 ----
    public var method: HTTPMethod = .post
    public var encoding: RequestEncoding = .json
    public var url: String
    public var headers: HTTPHeaders = HTTPHeaders()
    public var parameters: Param? {
        if method == .post {
            return body
        }
        
        return query
    }
    
    
    public var files: [UploadFileModel] = []
    
    public var progress: Request.ProgressHandler? = nil
    
    /// 请求时的loading配置
    public var uiConfig : HTTPUIConfig?
    
    
    public var timeoutIntervalForRequest: TimeInterval?
    
    
    /// Post传参是数组时使用
    public var bodys: [Param]?
    
    
    //MARK: -------------------- Public ------------------------
    
    public init(url: String, method: HTTPMethod = .post, encoding: RequestEncoding = .json, uiConfig : HTTPUIConfig?) {
        self.url = url
        self.method = method
        self.encoding = encoding
        self.uiConfig = uiConfig
    }

    public func header(_ param: HTTPHeader) -> Self {
        headers.update(param)
        return self
    }
    
    
    
    /// 传map时使用, 传入后params传入的bodys失效
    public func param(_ param: Param?) -> Self {
        return method == .post ? post(param) : get(param)
    }
    
    
    /// 仅数组时使用, 传入后param/init传入的param失效
    public func params(_ params: [Param]) -> Self {
        bodys = params
        body = nil
        return self
    }



    fileprivate var query: Param = [:]
    fileprivate var body: Param?
    
}

// MARK: - --- private ----
extension HTTPRequestConfig {
    
    internal var parameterEncoding: ParameterEncoding {
        switch encoding {
        case .url:
            return URLEncoding.default
        case .json:
            return JSONEncoding.default
        }
    }
    
    fileprivate func get(_ param: Param?) -> Self {
        query += param ?? [:]
        return self
    }

    fileprivate func post(_ param: Param?) -> Self {
        if body == nil { body = [:] }
        body? += param ?? [:]
        bodys = nil
        return self
    }
}
