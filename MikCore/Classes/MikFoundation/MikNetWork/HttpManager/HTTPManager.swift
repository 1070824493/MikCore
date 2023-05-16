//
//  HTTPManager.swift
//  MikCore
//
//  Created by ty on 2021/10/23.
//

import Alamofire
import HandyJSON
import RxSwift
import SwiftyJSON
import UIKit

/// HandyJSON
public typealias MikRequestModelResult<T: HandyJSON> = Result<MikStandardModel<T>, MikError>
public typealias MikRequestModelHandler<T: HandyJSON> = (MikRequestModelResult<T>) -> Void

/// SwiftyJSON
public typealias MikRequestJSONResult = Result<JSON, MikError>
public typealias MikRequestJSONHandler = (MikRequestJSONResult) -> Void

public class HTTPManager<Target: HTTPTarget> {
    fileprivate let session: Session

    /// 是否禁用代理
    private let enableProxy: Bool
    private let queue = DispatchQueue(label: "com.mik.httpRequest-queue", qos: .utility, attributes: .concurrent)
    private let retryInterceptor = RetryInterceptor() // 整个session生效,用于重试

    /// unused TODO: HTTP Logger
    private let plugins: [HTTPPlugin]?

    private class func initSession(interceptor: RequestInterceptor?) -> Alamofire.Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let session = Session(configuration: configuration, interceptor: interceptor)
        return session
    }

    public init(plugins: [HTTPPlugin]? = nil, enableProxy: Bool = true) {
        self.session = HTTPManager.initSession(interceptor: retryInterceptor)
        self.plugins = plugins
        self.enableProxy = enableProxy
    }
}

public extension HTTPHeader {
    static func contentTypeForm() -> HTTPHeader {
        return HTTPHeader.contentType("application/x-www-form-urlencoded; charset=utf-8")
    }

    static func contentTypeJSON() -> HTTPHeader {
        return HTTPHeader.contentType("application/json")
    }
}

// MARK: - - Public ----

// MARK: - --- Model With Callback ----

extension HTTPManager: HTTPProvider {
    @discardableResult
    public func requestModelArray<M>(target: Target, model: M.Type, parameters: [String: Any]? = nil, body: Any? = nil, callback: @escaping MikRequestModelHandler<M>) -> DataRequest? where M: HandyJSON {

        do {
            let request = try self.getRequest(parameters: parameters, body: body, target: target).validate(statusCode: target.validateCode)
            plugins?.forEach { $0.willSend(request) }
            queue.async {
                request.responseModelArray(map: model, queue: target.callbackQueue ?? .main) { [weak self] response in
                    guard let `self` = self else { return }
                    self.handerModelResponse(response, dataRequest: request, callback: callback)
                }
            }
            return request
        } catch {
            callback(.failure(MikError.invalidURL))
            return nil
        }
    }

    @discardableResult
    public func requestModelMap<M>(target: Target, model: M.Type, parameters: [String: Any]? = nil, body: Any? = nil, callback: @escaping MikRequestModelHandler<M>) -> DataRequest? where M: HandyJSON {
        do {
            let request = try self.getRequest(parameters: parameters, body: body, target: target).validate(statusCode: target.validateCode)
            plugins?.forEach { $0.willSend(request) }
            queue.async {
                request.responseModelMap(map: model, queue: target.callbackQueue ?? .main) { [weak self] response in
                    guard let `self` = self else { return }
                    self.handerModelResponse(response, dataRequest: request, callback: callback)
                }
            }
            return request
        } catch {
            callback(.failure(MikError.invalidURL))
            return nil
        }
    }

    @discardableResult
    public func requestSwiftyJSON(target: Target, parameters: [String: Any]? = nil, body: Any? = nil, callback: @escaping MikRequestJSONHandler) -> DataRequest? {
        /// request
        do {
            let request = try self.getRequest(parameters: parameters, body: body, target: target).validate(statusCode: target.validateCode)
            plugins?.forEach { $0.willSend(request) }
            queue.async {
                request.responseSwiftyJSON(queue: target.callbackQueue ?? .main) { [weak self] response in
                    guard let `self` = self else { return }
                    self.handerJSONResponse(response, dataRequest: request, callback: callback)
                }
            }
            return request
        } catch {
            if let e = error as? MikError {
                callback(.failure(e))
            }else{
                callback(.failure(MikError.invalidURL))
            }
            return nil
        }
    }

    @discardableResult
    public func requestModel<M: HandyJSON>(target: Target, model: M.Type, parameters: [String: Any]? = nil, body: Any? = nil, callback: @escaping MikRequestModelHandler<M>) -> DataRequest? {
        do {
            let request = try self.getRequest(parameters: parameters, body: body, target: target).validate(statusCode: target.validateCode)
            plugins?.forEach { $0.willSend(request) }
            queue.async {
                request.responseModel(map: model, queue: target.callbackQueue ?? .main) { [weak self] response in
                    guard let `self` = self else { return }
                    self.handerModelResponse(response, dataRequest: request, callback: callback)
                }
            }
            return request
        } catch {
            callback(.failure(MikError.invalidURL))
            return nil
        }
    }
}

// MARK: - --- Extension Request With RxSwift ----

public extension HTTPManager {
    func requestModelRx<M>(target: Target, model: M.Type, parameters: [String: Any]? = nil, body: Any? = nil) -> Observable<MikRequestModelResult<M>> where M: HandyJSON {
        return Observable<MikRequestModelResult<M>>.create { obs in

            let request = self.requestModel(target: target, model: model, parameters: parameters, body: body) { result in
                defer { obs.onCompleted() }
                obs.onNext(result)
            }
            return Disposables.create { request?.cancel() }
        }
    }

    func requestSwiftyJSONRx(target: Target, parameters: [String: Any]? = nil, body: Any? = nil) -> Observable<MikRequestJSONResult> {
        return Observable<MikRequestJSONResult>.create { obs in
            let request = self.requestSwiftyJSON(target: target, parameters: parameters, body: body) { result in
                defer { obs.onCompleted() }
                obs.onNext(result)
            }
            return Disposables.create { request?.cancel() }
        }
    }
}

// MARK: - - Private ----

extension HTTPManager {
    /// 构造请求
    private func getRequest(parameters: [String: Any]?, body: Any?, target: HTTPTarget) throws -> DataRequest {
        if enableProxy == false, isUsedProxy() == true { throw MikError.proxyDisabled }
        if target.path.contains("?") { throw MikError.pathFormatError }
        guard let path = target.path.mik.afUrlEncoding() else { throw MikError.invalidURL }

        let request = session.request(target.fullUrl, method: target.method,
                                      parameters: parameters,
                                      encoding: target.parameterEncoding,
                                      headers: target.headers) { urlRequest in
            if let bodys = body, let data = try? JSONSerialization.data(withJSONObject: bodys, options: .fragmentsAllowed) {
                urlRequest.httpBody = data
            } else if let body = body as? String, let httpBody = body.data(using: .utf8) {
                urlRequest.httpBody = httpBody
            }
            if let timeoutIntervalForRequest = target.timeoutIntervalForRequest {
                urlRequest.timeoutInterval = timeoutIntervalForRequest
            }

            self.plugins?.forEach { $0.prepare(&urlRequest) }

        }

        request.parameter = parameters
        request.body = body
        request.target = target
        retryInterceptor.target = target // 默认拦截器
        return request
    }

    /// 错误处理
    private func handerRequestError(error: AFError? = nil, data: Data?) -> MikError {
        func handerErrorData() -> MikError {
            guard let data = data else { return .deserializeNil }
            var standardModel = MikStandardModel<MikEmptyModel>()
            do {
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any], let model = MikStandardModel<MikEmptyModel>.deserialize(from: json) {
                    // 返回的错误是标准格式
                    standardModel = model
                } else if let str = String(data: data, encoding: .utf8) {
                    // 返回的错误是字符串
                    standardModel.message = str
                } else {
                    // 其他异常格式
                    let json = try JSON(data: data)
                    print("错误信息返回了map与string以外的其他异常格式, 需要确认是否需要处理")
                    return .errorFormatError
                }

            } catch {
                return .errorFormatError
            }

            // 兼容之前的错误处理逻辑,将标准模型解析的数据更新到现有模型
            let errorInfo: MikResponseErrorInfoModel? = {
                guard let errorJson = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    return nil
                }
                var info = MikResponseErrorInfoModel.deserialize(from: errorJson)
                info?.httpCode = error?.responseCode

                // 更新标准返回内容
                if info?.message?.isEmpty ?? true {
                    info?.message = standardModel.message
                }
                info?.code = standardModel.code
                info?.data = data

                return info
            }()

            return .requestError(info: errorInfo)
        }

        switch error {
        case .explicitlyCancelled:
            return .cancel
        case .invalidURL:
            return .invalidURL
        case .responseSerializationFailed(reason: _):
            return .responseSerializationFailed(error)
        default:
            return handerErrorData()
        }
    }

    /// 统一处理Model response
    private func handerModelResponse<M: HandyJSON>(_ response: DataResponse<MikStandardModel<M>, AFError>, dataRequest: DataRequest, callback: @escaping MikRequestModelHandler<M>) {

        switch response.result {
        case .success(let value):
            callback(.success(value))
            if let data = response.data {
                self.plugins?.forEach { $0.didReceive(dataRequest, result: .success(try? JSON(data: data))) }
            }
        case .failure(let error):
            let e = self.handerRequestError(error: error, data: response.data)
            callback(.failure(e))
            if let data = response.data {
                self.plugins?.forEach { $0.didReceive(dataRequest, result: .failure(e)) }
            }
        }
    }

    /// 统一处理JSON response
    private func handerJSONResponse(_ response: AFDataResponse<JSON>, dataRequest: DataRequest, callback: @escaping MikRequestJSONHandler) {

        switch response.result {
        case .success(let value):
            callback(.success(value))
            if let data = response.data {
                self.plugins?.forEach { $0.didReceive(dataRequest, result: .success(value)) }
            }
        case .failure(let error):
            let e = self.handerRequestError(error: error, data: response.data)
            callback(.failure(e))
            if let data = response.data {
                self.plugins?.forEach { $0.didReceive(dataRequest, result: .failure(e)) }
            }
        }

    }
    /// 判断代理
    private func isUsedProxy() -> Bool {
        guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { return false }
        guard let dict = proxy as? [String: Any] else { return false }
        guard let http = dict["HTTPProxy"] as? String, http.count > 0 else { return false }
        guard let https = dict["HTTPSProxy"] as? String, https.count > 0 else { return false }
        return true
    }


}
