//
//  DataRequest+Extension.swift
//  MikCore
//
//  Created by ty on 2021/10/23.
//

import Alamofire
import Foundation
import HandyJSON
import SwiftyJSON

extension DataRequest {
    static var configKey: Void?
    var config: HTTPRequestConfig? {
        get {
            return objc_getAssociatedObject(self, &DataRequest.configKey) as? HTTPRequestConfig
        }
        set {
            objc_setAssociatedObject(self, &DataRequest.configKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @discardableResult
    func responseSwiftyJSON(queue: DispatchQueue = .main, completionHandler: @escaping (AFDataResponse<JSON>) -> Void) -> Self {
        let serializer = SwiftJSONResponseSerializer()
        return response(queue: queue, responseSerializer: serializer, completionHandler: completionHandler)
    }

    
    @discardableResult
    func responseModel<T: HandyJSON>(map type: T.Type, queue: DispatchQueue = .main, completionHandler: @escaping (AFDataResponse<MikStandardModel<T>>) -> Void) -> Self {
        let serializer = ModelResponseSerializer<T>.init()
        return response(queue: queue, responseSerializer: serializer, completionHandler: completionHandler)
    }

    // MARK: - --- 解析器 ----

    /// SwiftJSON 解析器
    final class SwiftJSONResponseSerializer: ResponseSerializer {
        public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> JSON {
            guard error == nil else { throw error! }

            guard let data = data, !data.isEmpty else {
                guard emptyResponseAllowed(forRequest: request, response: response) else {
                    throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                }

                return JSON()
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                return JSON(json)
            } catch {
                return JSON()
            }
        }
    }

    
    /// T类型解析器
    final class ModelResponseSerializer<T: HandyJSON>: ResponseSerializer {
        init() {}

        public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> MikStandardModel<T> {
            guard error == nil else { throw error! }

            let mikBaseModel = MikStandardModel<T>()
            guard let data = data, !data.isEmpty else {
                guard emptyResponseAllowed(forRequest: request, response: response) else {
                    throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                }
                
                return mikBaseModel
            }

            do {
                // T 标准格式解析
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    guard let root = T.deserialize(from: json, designatedPath: nil) else {
                        return mikBaseModel
                    }
                    mikBaseModel.data = root
                    
                    //解析标准格式code/data/message
                    guard let standardResponse = MikStandardModel<T>.deserialize(from: json) else {
                        return mikBaseModel
                    }
                    
                    
                    return standardResponse
                }
                // [T] : 非标准格式解析(后台如果返回格式标准, 将不会再存在这种直接解析数组的情况)
                else if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] {
                    guard let root = [T].deserialize(from: json)?.compactMap({ $0 }) else {
                        return mikBaseModel
                    }
                    mikBaseModel.datas = root
                    mikBaseModel.code = "200"
                    return mikBaseModel
                }
                // 异常格式: 没有MikStandardModel中的code,data,message包装,也不是数组
                else {
                    
                    print("异常格式,暂未处理:---url: \(request?.url) \n, ---data: \(String(data: data, encoding: .utf8))")
                    return mikBaseModel
                }
            }
            catch {
                return mikBaseModel
            }
        }
    }
}
