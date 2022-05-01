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

public protocol HTTPPlugin {}

public typealias MikRequestModelResult<T: HandyJSON> = Result<MikStandardModel<T>, MikError>
public typealias MikRequestModelHandler<T: HandyJSON> = (MikRequestModelResult<T>) -> Void

public typealias MikRequestJSONResult = Result<JSON, MikError>
public typealias MikRequestJSONHandler = (MikRequestJSONResult) -> Void

public class HTTPManager<Target: HTTPTarget> {
    fileprivate let session: Session
    private let queue = DispatchQueue(label: "com.mik.httpRequest-queue", qos: .utility, attributes: .concurrent)
    private let retryInterceptor = RetryInterceptor()   //整个session生效,用于重试

    /// unused TODO: HTTP Logger
    private let plugins: [HTTPPlugin]?

    private class func initSession(interceptor: RequestInterceptor?) -> Alamofire.Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let session = Session(configuration: configuration, interceptor: interceptor)
        return session
    }

    public init(callbackQueue: DispatchQueue? = nil, plugins: [HTTPPlugin]? = nil) {
        self.plugins = plugins
        self.session = HTTPManager.initSession(interceptor: retryInterceptor)
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
//MARK: ---- Model With Callback ----
extension HTTPManager: HTTPProvider {

    @discardableResult
    public func requestModelArray<M>(target: Target, model: M.Type, parameters: [String : Any]? = nil, body: Any? = nil, callback: @escaping MikRequestModelHandler<M>) -> DataRequest? where M : HandyJSON {
        var request: DataRequest?

        do {
            let request = try self.getRequest(parameters: parameters, body: body, target: target).validate(statusCode: target.validateCode)
            queue.async {
                request.responseModelArray(map: model, queue: target.callbackQueue ?? .main) { [weak self] response in
                    guard let `self` = self else { return }
                    switch response.result {
                    case .success(let value):
                        callback(.success(value))
                    case .failure(let error):
                        callback(.failure(self.handerRequestError(error: error, data: response.data)))
                    }
                }
            }
            return request
        } catch {
            callback(.failure(MikError.invalidURL))
            return nil
        }
    }

    @discardableResult
    public func requestModelMap<M>(target: Target, model: M.Type, parameters: [String : Any]? = nil, body: Any? = nil, callback: @escaping MikRequestModelHandler<M>) -> DataRequest? where M : HandyJSON {
        var request: DataRequest?

        do {
            let request = try self.getRequest(parameters: parameters, body: body, target: target).validate(statusCode: target.validateCode)
            queue.async {
                request.responseModelMap(map: model, queue: target.callbackQueue ?? .main) { [weak self] response in
                    guard let `self` = self else { return }
                    switch response.result {
                    case .success(let value):
                        callback(.success(value))
                    case .failure(let error):
                        callback(.failure(self.handerRequestError(error: error, data: response.data)))
                    }
                }
            }
            return request
        } catch {
            callback(.failure(MikError.invalidURL))
            return nil
        }
    }

    @discardableResult
    public func requestSwiftyJSON(target: Target, parameters: [String : Any]? = nil, body: Any? = nil, callback: @escaping MikRequestJSONHandler) -> DataRequest? {
        var request: DataRequest?

        do {
            let request = try self.getRequest(parameters: parameters, body: body, target: target).validate(statusCode: target.validateCode)
            queue.async {
                request.responseSwiftyJSON(queue: target.callbackQueue ?? .main) { [weak self] response in
                    guard let `self` = self else { return }
                    switch response.result {
                    case .success(let value):
                        callback(.success(value))
                    case .failure(let error):
                        let afErr = error as? AFError
                        callback(.failure(self.handerRequestError(error: error, data: response.data)))
                    }
                }
            }
            return request
        } catch {
            callback(.failure(MikError.invalidURL))
            return nil
        }
    }


    @discardableResult
    public func requestModel<M: HandyJSON>(target: Target, model: M.Type, parameters: [String: Any]? = nil, body: Any? = nil, callback: @escaping MikRequestModelHandler<M>) -> DataRequest? {
        var request: DataRequest?

        do {
            let request = try self.getRequest(parameters: parameters, body: body, target: target).validate(statusCode: target.validateCode)
            queue.async {
                request.responseModel(map: model, queue: target.callbackQueue ?? .main) { [weak self] response in
                    guard let `self` = self else { return }
                    switch response.result {
                    case .success(let value):
                        callback(.success(value))
                    case .failure(let error):
                        callback(.failure(self.handerRequestError(error: error, data: response.data)))
                    }
                }
            }
            return request
        } catch {
            callback(.failure(MikError.invalidURL))
            return nil
        }
    }
}

//MARK: ---- Extension Request With RxSwift ----
extension HTTPManager {
    public func requestModelRx<M>(target: Target, model: M.Type, parameters: [String : Any]? = nil, body: Any? = nil) -> Observable<MikRequestModelResult<M>> where M : HandyJSON {
        return Observable<MikRequestModelResult<M>>.create { obs in

            let request = self.requestModel(target: target, model: model, parameters: parameters, body: body) { result in
                defer { obs.onCompleted() }
                obs.onNext(result)
            }
            return Disposables.create { request?.cancel() }
        }
    }

    public func requestSwiftyJSONRx(target: Target, parameters: [String : Any]? = nil, body: Any? = nil) -> Observable<MikRequestJSONResult> {
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
//        if let mockData = target.mockData {
//            session.sessionConfiguration.protocolClasses?.insert(MockProtocalClass.self, at: 0)
//        }
        if target.path.contains("?") { throw MikError.pathFormatError }
        guard let path = target.path.mik.afUrlEncoding() else { throw MikError.invalidURL }

        let url = [target.baseURL, target.rootPath, path].compactMap { $0 }.joined(separator: "")
        let request = session.request(url, method: target.method,
                                      parameters: parameters,
                                      encoding: target.parameterEncoding,
                                      headers: target.headers) { urlRequest in
            if let bodys = body, let data = try? JSONSerialization.data(withJSONObject: bodys, options: .fragmentsAllowed) {
                urlRequest.httpBody = data
            }
            else if let body = body as? String, let httpBody = body.data(using: .utf8) {
                urlRequest.httpBody = httpBody
            }
            if let timeoutIntervalForRequest = target.timeoutIntervalForRequest {
                urlRequest.timeoutInterval = timeoutIntervalForRequest
            }
        }
    
        request.target = target
        retryInterceptor.target = target //默认拦截器
        return request
    }

    /// 错误处理
    private func handerRequestError(error: AFError, data: Data?) -> MikError {
        switch error {
        case .explicitlyCancelled:
            return .cancel
        case .invalidURL:
            return .invalidURL
        default:

            guard let data = data else { return .deserializeNil }
            var standardModel = MikStandardModel<MikEmptyModel>()
            do {
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any], let model = MikStandardModel<MikEmptyModel>.deserialize(from: json) {
                    //返回的错误是标准格式
                    standardModel = model
                }else if let str = String(data: data, encoding: .utf8) {
                    //返回的错误是字符串
                    standardModel.message = str
                }else{
                    //其他异常格式
                    let json = try JSON.init(data: data)
                    print("错误信息返回了map与string以外的其他异常格式, 需要确认是否需要处理")
                    return .errorFormatError
                }

            } catch {
                return .errorFormatError
            }

            //兼容之前的错误处理逻辑,将标准模型解析的数据更新到现有模型
            let errorInfo: MikResponseErrorInfoModel? = {
                guard let errorJson = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    return nil
                }
                var info = MikResponseErrorInfoModel.deserialize(from: errorJson)
                info?.httpCode = error.responseCode

                //更新标准返回内容
                if info?.message?.isEmpty ?? true {
                    info?.message = standardModel.message
                }
                info?.code = standardModel.code
                info?.data = standardModel.data
                
                return info
            }()

            return .requestError(info: errorInfo)
        }
    }
}
