//
//  MikResponse.swift
//  Demo
//
//  Created by gaowei on 2021/4/17.
//

import Foundation
import HandyJSON

public struct MikResponse {
    
    public init(value: Any?) {
        self.rawValue = value
    }

    public let rawValue: Any?
    
    public var json: [String: Any]? {
        if let jsonValue = rawValue as? [String: Any] {
            return jsonValue
        }else if let stringValue = rawValue as? String, let dataValue = stringValue.data(using: String.Encoding.utf8) {
            return try? JSONSerialization.jsonObject(with: dataValue, options: .allowFragments) as? [String: Any]
        }
        return nil
    }
    
    public var code: Int? {
        guard let code = self.json?["code"] as? String else {
            return nil
        }
        return Int(code)
    }
    
    public var failedWhenAFSucceed: Bool {
        if let code = json?["code"] as? String, code == "200" {
            return false
        }
        return true
    }
    
    public var error: MikError? {
        guard let errorInfo = MikResponseErrorInfoModel.deserialize(from: self.json) else {
            return nil
        }
        return .requestError(info: errorInfo)
    }
    
}

public extension MikResponse  {
            
    var json_data: [String: Any]? { self.json?["data"] as? [String: Any] }
    
    var json_datas: [[String: Any]]? { self.json?["data"] as? [[String: Any]] }
    
}

public struct MikResponseModel<T>: HandyJSON {
    
    public init() {}
    
    public var code: String?
    public var message: String?
    public var data: T?
    
}
