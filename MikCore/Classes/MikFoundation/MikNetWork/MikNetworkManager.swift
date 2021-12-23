//
//  MikNetworkManager.swift
//  Demo
//
//  Created by gaowei on 2021/4/17.
//

import Foundation
import Alamofire

public typealias MikDataRequest = DataRequest
public typealias MikRequestResultHandler = (Result<MikResponse, MikError>) -> Void

extension String {
    fileprivate static func toJson(_ params: AnyObject) -> String {
        if params is String {
            return stringToJson(string: params as! String)
        } else {
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        }
    }
    fileprivate static func stringToJson(string: String) -> String{
        let s = NSMutableString.init(string: string)
        s.replacingOccurrences(of: "\"", with: "\\\"", options: .caseInsensitive, range: NSRange.init(location: 0, length: s.length))
        s.replaceOccurrences(of: "/", with: "\\/", options: .caseInsensitive, range: NSRange.init(location: 0, length: s.length))
        s.replaceOccurrences(of: "\n", with: "\\n", options: .caseInsensitive, range: NSRange.init(location: 0, length: s.length))
        s.replaceOccurrences(of: "\r", with: "\\r", options: .caseInsensitive, range: NSRange.init(location: 0, length: s.length))
        s.replaceOccurrences(of: "\t", with: "\\t", options: .caseInsensitive, range: NSRange.init(location: 0, length: s.length))
        return NSString.init(string: s) as String
    }
    
    fileprivate func encode(_ params: Parameters) -> String {
        return URLRequest(url: URL(string:self)!).request(with: params).url?.absoluteString ?? self
    }
}

extension URLRequest {
    fileprivate func request(with params: Parameters?) -> URLRequest {
        guard let params = params else { return self }
        
        var urlComponent = URLComponents(string: (self.url?.absoluteString)!)!
        let queryItems = params.map{ URLQueryItem(name: $0.key, value: "\($0.value)") }
        urlComponent.queryItems = queryItems
        return URLRequest(url: urlComponent.url!)
    }
}


public enum MethodType: String {
    case GET = "GET"
    case POST = "POST"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case PUT = "PUT"
}

public enum ResponseType {
    case none
    case json
    case string
    case data
}

public enum UploadName: String {
    case FILES = "files"
    case VIDEO = "video"
    case PDF = "pdf"
}

public protocol MikNetworkerProtocol: AnyObject {
    var token: String? { get }
}


public class MikNetworkManager {
    public static let shared = MikNetworkManager()
    
    weak public var config: MikNetworkerProtocol?
    
    public var errorCode: [Int] = [401, 403]
    public var takeErrorCodeBlock: ((_ code: Int) -> ())?
    
    public var isDebug: Bool = true
    
    public var successCode: String = "200"
    
    public var headers: HTTPHeaders {
        var httpHeaders = HTTPHeaders(self.defaultHeaders)
        if let token = self.config?.token, !token.isEmpty {
            httpHeaders.add(HTTPHeader.authorization(bearerToken: token))
        }
        
        return httpHeaders
    }
    
    private let defaultHeaders = [HTTPHeader.contentType("application/json")]
    
    public var timeoutIntervalForRequest: TimeInterval = 60.0
    
    private init() {}
}

extension MikNetworkManager {
    /// Data Request
    /// - params:
    ///   - params: Array or Dictionary or String
    private func request(url: String, method: MethodType, params: [String: Any]?, bodys: AnyObject?, responseType: ResponseType, success: @escaping (_ success: Any) -> (), failure: @escaping (_ error: MikError) -> ()) {
        if self.isDebug {
            MikPrint("url: \(url) \n params: \(String(describing: params)) \n bodys: \(String(describing: bodys))")
        }
        
        if Self.CheckProxySetting(urlString: url) && !self.isDebug {
            let model = MikResponseErrorInfoModel.init(message: "Please close the proxy and try again")
            failure(MikError.requestError(info: model))
            return
        }
    
        // utf-8 编码
//        guard let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        var requestUrl = URL(string: url.replacingOccurrences(of: " ", with: ""))!
        if params?.count ?? 0 > 0 {
            requestUrl = URL(string: url.encode(params!))!
        }
        var request = URLRequest(url: requestUrl, timeoutInterval: self.timeoutIntervalForRequest)
        request.httpMethod = method.rawValue
        
        self.headers.dictionary.keys.forEach { (key) in
            request.setValue(headers[key], forHTTPHeaderField: key)
        }
        
        if bodys?.count ?? 0 > 0 {
            let jsonSting = String.toJson(bodys!)
            let jsonData = jsonSting.data(using: .utf8, allowLossyConversion: false)!
            request.httpBody = jsonData
        }
        
        let dataRequest = AF.request(request)
        let beginTime = Date().timeIntervalSince1970
        switch responseType {
        case .none:
            dataRequest.response { [weak self](response) in
                guard let self = self else { return }
                self.dealRequestComplete(url: url, method: method, urlParams: params, bodys: bodys, header: self.headers.dictionary, beginTime: beginTime, response: response, success: success, failure: failure)
            }
        case .json:
            dataRequest.responseJSON { [weak self](response) in
                guard let self = self else { return }
                self.dealRequestComplete(url: url, method: method, urlParams: params, bodys: bodys, header: self.headers.dictionary, beginTime: beginTime, response: response, success: success, failure: failure)
            }
        case .string:
            dataRequest.responseString(encoding:.utf8) { [weak self](response) in
                guard let self = self else { return }
                self.dealRequestComplete(url: url, method: method, urlParams: params, bodys: bodys, header: self.headers.dictionary, beginTime: beginTime, response: response, success: success, failure: failure)
            }
        default:
            dataRequest.responseData { [weak self](response) in
                guard let self = self else { return }
                self.dealRequestComplete(url: url, method: method, urlParams: params, bodys: bodys, header: self.headers.dictionary, beginTime: beginTime, response: response, success: success, failure: failure)
            }
            break
        }
    }
    /// Processing request callbacks
    /// - params:
    ///   - response: response data
    ///   - success: success callback
    ///   - failure: failure callback
    /// - Returns: void
    private func dealRequestComplete<T>(url : String,
                                        method: MethodType,
                                        urlParams : [String : Any]?,
                                        bodys : AnyObject?,
                                        header : [String : Any],
                                        beginTime : TimeInterval,
                                        response : AFDataResponse<T>, success: @escaping (_ success: Any) -> (), failure: @escaping (_ error: MikError) -> ()){
        
        let endTime = Date().timeIntervalSince1970
        let duration = endTime - beginTime
        var logModel = MikLogModel()
        logModel.url = url
        logModel.method = method.rawValue
        logModel.params = bodys as? [String : Any]
        logModel.requestHeader = header
        logModel.requestTime = beginTime
        logModel.requestDuration = duration
        logModel.responseTime = endTime
        logModel.responseHeader = response.response?.allHeaderFields as? [String : Any]
        logModel.httpCode = response.response?.statusCode
        
        switch response.result {
        case .success(_):
            let mikRes = MikResponse.init(value: response.value)
            
            if mikRes.failedWhenAFSucceed {
                logModel.response = String(data: response.data ?? Data(), encoding: .utf8)
                logModel.errorDescription = (response.error?.errorDescription ?? "") + "\n" + (response.error?.localizedDescription ?? "")
            }else{
                logModel.isSuccess = true
            }
            MikLog.saveApiLog(model: logModel)
            success(response.value as Any)
        case .failure(let error):
            logModel.response = String(data: response.data ?? Data(), encoding: .utf8)
            logModel.errorDescription = error.errorDescription ?? "" + "\n" + error.localizedDescription
            MikLog.saveApiLog(model: logModel)
            
            if let code = response.error?.responseCode, self.errorCode.contains(code) {
                self.takeErrorCodeBlock?(code)
            }
            
            let errorInfo: MikResponseErrorInfoModel? = {
                guard let data = response.data, let errorJson = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else {
                    return nil
                }
                var info = MikResponseErrorInfoModel.deserialize(from: errorJson)
                info?.code = error.responseCode
                return info
            }()

            failure(.requestError(info: errorInfo))
        }
    }
}

public extension MikNetworkManager {
    
    static private func CheckProxySetting(urlString: String?) -> Bool {
        
//        AF.session.configuration.connectionProxyDictionary = [:]
    
        func QCFNetworkCopySystemProxySettings() -> CFDictionary? {
            guard let proxiesSettingsUnmanaged = CFNetworkCopySystemProxySettings() else {
                return nil
            }
            return proxiesSettingsUnmanaged.takeRetainedValue()
        }
        
        func QCFNetworkCopyProxiesForURL(_ url: URL, _ proxiesSettings: CFDictionary) -> [[String: AnyObject]] {
            let proxiesUnmanaged = CFNetworkCopyProxiesForURL(url as CFURL, proxiesSettings)
            let proxies = proxiesUnmanaged.takeRetainedValue()
            return proxies as! [[String: AnyObject]]
        }
        
        if let myUrl = URL(string: (urlString ?? "https://www.google.com")) {
            if let proxySettings = QCFNetworkCopySystemProxySettings() {
                let proxies = QCFNetworkCopyProxiesForURL(myUrl, proxySettings)
                if let v = (proxies.first?["kCFProxyTypeKey"] as? String), !v.isEmpty, !v.hasSuffix("None") {
                    return true
                }
            }
        }
        return false
    }
}


// MARK: - Data Request
public extension MikNetworkManager {
    
    func request(url: String, method: MethodType, params: [String: Any]?, bodys: AnyObject?, success: @escaping (_ success: Any) -> (), failure: @escaping (_ error: MikError) -> ()) {
        
        return self.request(url: url, method: method, params: params, bodys: bodys, responseType: .none) { (response) in
            success(response)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func requestToResponseString(url: String, method: MethodType, params: [String: Any]?, bodys: AnyObject?, success: @escaping (_ success: String) -> (), failure: @escaping (_ error: MikError) -> ()) {
        
        return self.request(url: url, method: method, params: params, bodys: bodys, responseType: .string) { (response) in
            success(response as! String)
        } failure: { (error) in
            failure(error)
        }
    }
    
    func requestToResponseJson(url: String, method: MethodType, params: [String: Any]?, bodys: AnyObject?, success: @escaping (_ success: Any) -> (), failure: @escaping (_ error: MikError) -> ()) {
        
        return self.request(url: url, method: method, params: params, bodys: bodys, responseType: .json) { (response) in
            success(response)
        } failure: { (error) in
            failure(error)
        }
    }

    func requestToResponseData(url: String, method: MethodType, params: [String: Any]?, bodys: AnyObject?, success: @escaping (_ success: Data?) -> (), failure: @escaping (_ error: MikError) -> ()) {
        
        return self.request(url: url, method: method, params: params, bodys: bodys, responseType: .data) { (response) in
            success(response as? Data)
        } failure: { (error) in
            failure(error)
        }
    }
}


// MARK: - ------------
extension MikNetworkManager {
    
    /// 解析请求结果
    /// - Parameters:
    ///   - response: 请求结果
    ///   - result: 解析完成回调
    private func paserResponse<T>(url : String,
                                  method: HTTPMethod,
                                  params : [String : Any]?,
                                  header : [String : Any],
                                  beginTime : TimeInterval,
                                  response: AFDataResponse<T>, result: MikRequestResultHandler?) {
        let endTime = Date().timeIntervalSince1970
        let duration = endTime - beginTime
        var logModel = MikLogModel()
        logModel.url = url
        logModel.method = method.rawValue
        logModel.params = params
        logModel.requestHeader = header
        logModel.requestTime = beginTime
        logModel.requestDuration = duration
        logModel.responseTime = endTime
        logModel.responseHeader = response.response?.allHeaderFields as? [String : Any]
        logModel.httpCode = response.response?.statusCode
        switch response.result {
        case .success(_):
            let mikRes = MikResponse.init(value: response.value)
            if mikRes.failedWhenAFSucceed {
                logModel.response = String(data: response.data ?? Data(), encoding: .utf8)
                logModel.errorDescription = (response.error?.errorDescription ?? "") + "\n" + (response.error?.localizedDescription ?? "")
            }else{
                logModel.isSuccess = true
            }
            MikLog.saveApiLog(model: logModel)
            result?(.success(MikResponse(value: response.value)))
        case .failure(let error):
            logModel.response = String(data: response.data ?? Data(), encoding: .utf8)
            logModel.errorDescription = error.errorDescription ?? "" + "\n" + error.localizedDescription
            MikLog.saveApiLog(model: logModel)
            
            switch error {
            case .explicitlyCancelled:
                result?(.failure(.cancel))
            default:
                let errorInfo: MikResponseErrorInfoModel? = {
                    guard let data = response.data, let errorJson = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else {
                        return nil
                    }
                    var info = MikResponseErrorInfoModel.deserialize(from: errorJson)
                    info?.code = error.responseCode
                    if info?.message?.isEmpty ?? true {
                        info?.message = error.localizedDescription
                    }
                    return info
                }()
                
                result?(.failure(.requestError(info: errorInfo)))
            }
        }
    }
    
    
    /// 发起网络请求
    /// - Parameters:
    ///   - url: 请求地址
    ///   - method: 请求方式
    ///   - responseType: 返回结果数据格式
    ///   - params: 参数
    ///   - result: 请求结果回调
    /// - Returns: 当次请求任务
    @discardableResult
    func request(url: String,
                 method: HTTPMethod,
                 responseType: ResponseType = .json,
                 params: Parameters? = nil,
                 encodeing: ParameterEncoding = URLEncoding.default,
                 headers: HTTPHeaders? = nil,
                 result: MikRequestResultHandler?) -> MikDataRequest? {
        
        if Self.CheckProxySetting(urlString: url) && !self.isDebug {
            let model = MikResponseErrorInfoModel.init(message: "Please close the proxy and try again")
            result?(.failure(MikError.requestError(info: model)))
            return nil
        }
        
        let dataRequest = AF.request(url, method: method, parameters: params, encoding: encodeing, headers: headers).validate()
        let beginTime = Date().timeIntervalSince1970
        switch responseType {
        case .json:
            dataRequest.responseJSON { [weak self] (response) in
                guard let self = self else { return }
                self.paserResponse(url: url, method: method, params: params, header: headers?.dictionary ?? [:], beginTime: beginTime, response: response, result: result)
            }
        case .string:
            dataRequest.responseString { [weak self] (response) in
                guard let self = self else { return }
                self.paserResponse(url: url, method: method, params: params, header: headers?.dictionary ?? [:], beginTime: beginTime, response: response, result: result)
            }
        case .data:
            dataRequest.responseData { [weak self] (response) in
                guard let self = self else { return }
                self.paserResponse(url: url, method: method, params: params, header: headers?.dictionary ?? [:], beginTime: beginTime, response: response, result: result)
            }
        default:
            dataRequest.response { [weak self] (response) in
                guard let self = self else { return }
                self.paserResponse(url: url, method: method, params: params, header: headers?.dictionary ?? [:], beginTime: beginTime, response: response, result: result)
            }
        }
                
        return dataRequest
    }
    
}


public enum MikParamerEncodeType {
    case url, json
    var encodeing: ParameterEncoding {
        switch self {
        case .url: return URLEncoding.default
        case .json: return JSONEncoding.default
        }
    }
}

public struct MikRequest {
    public let url: String
    
    /// 请求参数
    public var params: Parameters?
    /// 请求参数编码格式，默认为.json, .url: 参数将拼接在 URL 后面，.json: 参数
    public var encodeType: MikParamerEncodeType = .json
    public var headers: HTTPHeaders? = MikNetworkManager.shared.headers
    public var responseType: ResponseType = .json
    
    public init(url: String) {
        self.url = url
    }
}

public struct MikNetworker {
    
    @discardableResult
    public static func request(_ request: MikRequest, method: HTTPMethod, result: MikRequestResultHandler?) -> MikDataRequest? {
        return MikNetworkManager.shared.request(url: request.url, method: method, responseType: request.responseType, params: request.params, encodeing: request.encodeType.encodeing, headers: request.headers, result: result)
    }
    
    @discardableResult
    public static func request(url: String, method: HTTPMethod, result: MikRequestResultHandler?) -> MikDataRequest? {
        return Self.request(MikRequest(url: url), method: method, result: result)
    }
    
}
// --------



