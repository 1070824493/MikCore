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

public let businessSuccessCode = ["200", "1"]
public let successCode200 = "200"
public let successMessage = "Succeed"

extension DataRequest {
    static var configKey: Void?
    var target: HTTPTarget? {
        get {
            return objc_getAssociatedObject(self, &DataRequest.configKey) as? HTTPTarget
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
    func responseModel<M: HandyJSON>(map type: M.Type, queue: DispatchQueue = .main, completionHandler: @escaping (AFDataResponse<MikStandardModel<M>>) -> Void) -> Self {
        let serializer = ModelResponseSerializer<M>.init(emptyResponseCodes: target?.emptyResponseCodes)
        return response(queue: queue, responseSerializer: serializer, completionHandler: completionHandler)
    }

    @discardableResult
    func responseModelMap<M: HandyJSON>(map type: M.Type, queue: DispatchQueue = .main, completionHandler: @escaping (AFDataResponse<MikStandardModel<M>>) -> Void) -> Self {
        let serializer = ModelMapResponseSerializer<M>.init(emptyResponseCodes: target?.emptyResponseCodes)
        return response(queue: queue, responseSerializer: serializer, completionHandler: completionHandler)
    }

    @discardableResult
    func responseModelArray<M: HandyJSON>(map type: M.Type, queue: DispatchQueue = .main, completionHandler: @escaping (AFDataResponse<MikStandardModel<M>>) -> Void) -> Self {
        let serializer = ModelArrayResponseSerializer<M>.init(emptyResponseCodes: target?.emptyResponseCodes)
        return response(queue: queue, responseSerializer: serializer, completionHandler: completionHandler)
    }





}

//MARK: ---- ????????? ----
extension DataRequest {

    /// ???????????? -> JSON
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
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                    return JSON(json)
                }else if let str = String(data: data, encoding: .utf8) {
                    return JSON.init(stringLiteral: str)
                }else{
                    return try JSON.init(data: data)
                }

            } catch {
                throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
            }
        }
    }

    /// ????????????T -> ??????T??????
    final class ModelResponseSerializer<T: HandyJSON>: ResponseSerializer {
        public let emptyResponseCodes: Set<Int>

        init(emptyResponseCodes: Set<Int>? = nil) {
            self.emptyResponseCodes = emptyResponseCodes ?? DataResponseSerializer.defaultEmptyResponseCodes
        }

        public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> MikStandardModel<T> {
            guard error == nil else { throw error! }

            var mikBaseModel = MikStandardModel<T>()
            guard let data = data, !data.isEmpty else {
                guard emptyResponseAllowed(forRequest: request, response: response) else {
                    throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                }
                // ??????response????????????
                mikBaseModel.code = successCode200
                mikBaseModel.message = successMessage
                return mikBaseModel
            }

            do {
                // T ??????????????????
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    // ??????????????????code/data/message
                    guard var standardResponse = MikStandardModel<T>.deserialize(from: json) else {
                        throw MikError.deserializeNil
                    }

                    // ??????????????????data??????
                    if let arrayData = json["data"] as? [Any] {
                        guard let array = [T].deserialize(from: arrayData) else {
                            throw MikError.deserializeNil
                        }
                        standardResponse.datas = array.compactMap { $0 }
                        standardResponse.code = successCode200
                        return standardResponse
                    }

                    return standardResponse
                } else {
                    print("???????????????????????????,???????????????????????????:---url: \(request?.url) \n, ---data: \(String(data: data, encoding: .utf8))")
                    throw MikError.responseFormatError
                }
            } catch {
                throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
            }
        }
    }

    /// ???????????????[T] -> ??????T??????
    final class ModelArrayResponseSerializer<T: HandyJSON>: ResponseSerializer {
        public let emptyResponseCodes: Set<Int>

        init(emptyResponseCodes: Set<Int>? = nil) {
            self.emptyResponseCodes = emptyResponseCodes ?? DataResponseSerializer.defaultEmptyResponseCodes
        }

        public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> MikStandardModel<T> {
            guard error == nil else { throw error! }

            var mikBaseModel = MikStandardModel<T>()
            guard let data = data, !data.isEmpty else {
                guard emptyResponseAllowed(forRequest: request, response: response) else {
                    throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                }
                // ??????response????????????
                mikBaseModel.code = successCode200
                mikBaseModel.message = successMessage
                return mikBaseModel
            }

            do {
                //?????????????????????
                if let stringArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String] {

                    mikBaseModel.datas = stringArray as? [T]
                    mikBaseModel.code = successCode200
                    mikBaseModel.message = successMessage
                    return mikBaseModel
                }
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] {

                    guard let root = [T].deserialize(from: json)?.compactMap({ $0 }) else {
                        throw MikError.deserializeNil
                    }
                    mikBaseModel.datas = root
                    mikBaseModel.code = successCode200
                    mikBaseModel.message = successMessage
                    return mikBaseModel
                } else {
                    print("???????????????[T],???????????????????????????:---url: \(request?.url) \n, ---data: \(String(data: data, encoding: .utf8))")
                    throw MikError.responseFormatError
                }
            } catch {
                throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
            }
        }
    }

    /// ???????????????T -> ??????T??????
    final class ModelMapResponseSerializer<T: HandyJSON>: ResponseSerializer {
        public let emptyResponseCodes: Set<Int>

        init(emptyResponseCodes: Set<Int>? = nil) {
            self.emptyResponseCodes = emptyResponseCodes ?? DataResponseSerializer.defaultEmptyResponseCodes
        }

        public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> MikStandardModel<T> {
            guard error == nil else { throw error! }

            var mikBaseModel = MikStandardModel<T>()
            guard let data = data, !data.isEmpty else {
                guard emptyResponseAllowed(forRequest: request, response: response) else {
                    throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
                }
                // ??????response????????????
                mikBaseModel.code = successCode200
                mikBaseModel.message = successMessage
                return mikBaseModel
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]{
                    guard let root = T.deserialize(from: json) else {
                        throw MikError.deserializeNil
                    }
                    mikBaseModel.data = root
                    mikBaseModel.code = successCode200
                    mikBaseModel.message = successMessage
                    return mikBaseModel
                } else {
                    print("???????????????T,???????????????????????????:---url: \(request?.url) \n, ---data: \(String(data: data, encoding: .utf8))")
                    throw MikError.responseFormatError
                }
            } catch {
                throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
            }
        }
    }
}

