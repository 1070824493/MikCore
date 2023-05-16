//
//  QA_API.swift
//  MikCore_Example
//
//  Created by m7 on 2022/4/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MikCore
import Alamofire

 

public let providerQA = HTTPManager<QA_API>()

public enum QA_API {
    
    case cofactordigital(Cofactordigital_API)
    
}

fileprivate extension QA_API {

    var value: HTTPTarget {
        switch self {
        case .cofactordigital(let value):
            return value
        }
    }

}

extension QA_API: HTTPTarget {

    public var baseURL: String { value.baseURL }

    public var path: String { value.path }

    public var method: HTTPMethod { value.method }

    public var parameterEncoding: ParameterEncoding { value.parameterEncoding }

    public var headers: HTTPHeaders? { value.headers }

}


public enum Cofactordigital_API {
    
    case retail(id: String)
    
}

extension Cofactordigital_API: HTTPTarget {

    public var baseURL: String { "https://qa-api.cofactordigital.com" }

    public var rootPath: String? { nil }

    public var path: String {
        switch self {
        case .retail(_):
            return "/retail/495dca5c0cde6302/departments.json"
        }
    }

    public var method: HTTPMethod { .get }

    public var parameterEncoding: ParameterEncoding { URLEncoding.default }

    public var headers: HTTPHeaders? { HTTPHeaders.mikDefault }
    
}
