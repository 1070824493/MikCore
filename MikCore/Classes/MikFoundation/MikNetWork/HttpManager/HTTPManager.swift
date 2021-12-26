//
//  HTTPManager.swift
//  MikCore
//
//  Created by ty on 2021/10/23.
//

import Alamofire
import HandyJSON
import RxSwift
import UIKit
import SwiftyJSON

public protocol MikNetworkerProtocol: AnyObject {
    var token: String? { get }
}

public class HTTPManager: SessionDelegate {
    public weak static var config: MikNetworkerProtocol?

    fileprivate static let shared = HTTPManager()
    fileprivate static let sessionManager: Alamofire.Session = shared.initSessionManager()
    private static let queue = DispatchQueue(label: "com.mik.httpRequest-queue", qos: .utility, attributes: .concurrent)
    private func initSessionManager() -> Alamofire.Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 15
        configuration.timeoutIntervalForRequest = 30
        let manager = Alamofire.Session(configuration: configuration, delegate: self)
        return manager
    }
}

// MARK: - --- Public ----

public extension HTTPManager {
    /// Callback 调用方式
    /// 返回需要解析模型
    static func requestModel<T: HandyJSON>(type: T.Type, config: HTTPRequestConfig, callback: @escaping (MikStandardModel<T>?, Error?) -> Void) {
        showHudIfNeeded(config.uiConfig)
        HTTPManager.queue.async {
            let request = HTTPManager.getRequest(with: config)
            request.responseModel(map: type) { response in

                hideHudIfNeeded(config.uiConfig)
                callback(response.value, response.error)
            }
        }
    }
    

    /// RxSwift 调用方式
    /// 返回需要解析模型
    static func requestModelRx<T: HandyJSON>(config: HTTPRequestConfig) -> Observable<MikStandardModel<T>> {
        let subject = PublishSubject<MikStandardModel<T>>()
        let callback = RequestModelCallbackResponse(subject: subject)

        HTTPManager.request(type: T.self, config: config, callback: callback)
        return subject.asObservable()
    }
    
    /// ⚠️⚠️⚠️返回JSON: 当不需要解析模型或者不需要处理返回结果时使用,尽量避免使用!!!
    /// Callback 调用方式
    /// 无需解析模型的,用此方法,JSON类型可避免map错误取值/后台字段变更等引发的闪退
    static func requestSwiftyJSON(config: HTTPRequestConfig, callback: @escaping (JSON?, Error?) -> Void) {
        showHudIfNeeded(config.uiConfig)
        HTTPManager.queue.async {
            let request = HTTPManager.getRequest(with: config)
            request.responseSwiftyJSON { response in

                hideHudIfNeeded(config.uiConfig)
                callback(response.value, response.error)
            }
        }
    }
    
    /// ⚠️⚠️⚠️返回JSON: 当不需要解析模型或者不需要处理返回结果时使用,尽量避免使用!!!
    /// RxSwift 调用方式
    /// 无需解析模型的,用此方法,JSON类型可避免map错误取值/后台字段变更等引发的闪退
    static func requestSwiftyJSONRx(config: HTTPRequestConfig) -> Observable<JSON> {
        let subject = PublishSubject<JSON>()
        let callback = RequestJSONCallbackResponse(subject: subject)

        HTTPManager.request(config: config, callback: callback)
        return subject.asObservable()
    }
}

//MARK: -------------------- Upload ------------------------
public extension HTTPManager {
    
    static func upload(config: HTTPRequestConfig, callback: @escaping (JSON?, Error?) -> Void) {
        showHudIfNeeded(config.uiConfig)
        HTTPManager.queue.async {
            let request = HTTPManager.getUploadRequest(with: config)
            
            request.uploadProgress { (p) in
                MikPrint("upload.... \(p.completedUnitCount) / \(p.totalUnitCount)")
                config.progress?(p)
            }
            
            request.responseSwiftyJSON { response in
                hideHudIfNeeded(config.uiConfig)
                callback(response.value, response.error)
            }
        }
    }
}

// MARK: - --- Private ----

extension HTTPManager {
    /// 构造请求
    private static func getRequest(with config: HTTPRequestConfig) -> DataRequest {
        let url = config.url

        // 可在此拦截请求,配置header等
        // token
        if let token = HTTPManager.config?.token, !token.isEmpty {
            let tokenHeader = HTTPHeader.authorization(bearerToken: token)
            config.header(tokenHeader)
        }
        // json
        if config.headers["Content-Type"] == nil {
            let contentTypeHeader = HTTPHeader.contentType("application/json")
            config.header(contentTypeHeader)
        }

        let request = sessionManager.request(url, method: config.method,
                                             parameters: config.parameters,
                                             encoding: config.parameterEncoding,
                                             headers: config.headers) { urlRequest in
            if let bodys = config.bodys{
                let data = try? JSONSerialization.data(withJSONObject: bodys, options: .fragmentsAllowed)
                urlRequest.httpBody = data
            }
            if let timeoutIntervalForRequest = config.timeoutIntervalForRequest {
                urlRequest.timeoutInterval = timeoutIntervalForRequest
            }
        }
        
        request.config = config
        return request
    }
    
    /// 构造upload请求
    private static func getUploadRequest(with config: HTTPRequestConfig) -> DataRequest {

        let requestData = MultipartFormData()
        
        for (index, file) in config.files.enumerated() {
            if let data = file.data {
                let fileName: String = file.fileName ?? UploadFileModel.randomFileName(fileType: file.fileType, index: index)
                requestData.append(data, withName: file.fileType.withName, fileName: fileName, mimeType: file.fileType.mimeType)
            }
        }
        
        if let params = config.parameters, let paramsData = try? JSONSerialization.data(withJSONObject: params) {
            requestData.append(paramsData, withName: "contentRequest", fileName: "blob", mimeType: "application/json")
        }
        
        let uploadRequest = sessionManager.upload(multipartFormData: requestData, to: config.url, method: config.method, headers: config.headers)

        return uploadRequest
    }
}

// MARK: - --- HUD管理 ----

extension HTTPManager {
    private static func showHudIfNeeded(_ config: HTTPUIConfig?) {
        guard let hudConfig = config?.showHUDConifgure else {
            return
        }
        exchangeMainQueue {
            MikToast.showHUD(configure: hudConfig)
        }
    }

    private static func hideHudIfNeeded(_ config: HTTPUIConfig?) {
        guard let hudConfig = config?.showHUDConifgure else {
            return
        }
        exchangeMainQueue {
            MikToast.hideHUD(in: hudConfig.view)
        }
    }
}

/// 切换到主线程
public func exchangeMainQueue(_ handle: @escaping () -> Void) {
    if Thread.isMainThread {
        handle()

    } else {
        DispatchQueue.main.async {
            handle()
        }
    }
}
