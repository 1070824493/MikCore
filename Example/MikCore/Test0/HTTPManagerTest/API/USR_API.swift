//
//  USR_API.swift
//  MikCore_Example
//
//  Created by ty on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MikCore
import Alamofire


let providerUSR = HTTPManager<USR_API>()

public enum USR_API {

    case user(User_API)

    public enum User_API {
        case getPublicKey
    }
}

extension USR_API.User_API : HTTPTarget {
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .getPublicKey:
            return JSONEncoding.default
        }
    }

    public var baseURL: String {
        return "https://mik.qa.platform.michaels.com/api/usr"
    }

    public var rootPath: String? {
        return nil
    }

    public var path: String {
        switch self {
        case .getPublicKey: return "/user/get-public-key"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getPublicKey : return .get
        }
    }

    public var headers: HTTPHeaders? {

        var headers = HTTPHeaders([])
        switch self {
        case .getPublicKey:
            headers.update(HTTPHeader.contentTypeJSON())

        }

        return headers
    }


}


extension USR_API : HTTPTarget{
    public var parameterEncoding: ParameterEncoding {
        return value.parameterEncoding
    }

    public var baseURL: String {
        return value.baseURL
    }

    public var path: String {
        return value.path
    }

    public var rootPath: String? {
        return nil
    }

    public var method: HTTPMethod {
        return value.method
    }

    public var headers: HTTPHeaders? {
        return value.headers
    }

    public var retry: HTTPRetry {
        return value.retry
    }
}

fileprivate extension USR_API {
    var value : HTTPTarget {
        switch self {
        case .user(let user): return user
        }
    }
}
