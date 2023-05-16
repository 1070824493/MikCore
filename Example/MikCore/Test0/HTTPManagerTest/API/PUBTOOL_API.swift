//
//  PubtoolAPI.swift
//  MikCore_Example
//
//  Created by ty on 2022/4/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MikCore
import Alamofire

let providerPubtool = HTTPManager<PUBTOOL_API>()

public enum PUBTOOL_API {

    case conversation(Conversation)
    
}

extension PUBTOOL_API : HTTPTarget{
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

fileprivate extension PUBTOOL_API {
    var value : HTTPTarget {
        switch self {
        case .conversation(let conversation):
            return conversation
        }
    }
}

public enum Conversation {
    case topicSubscribe
    case fcmTokenChange
}

extension Conversation : HTTPTarget{
    public var rootPath: String? {
            return nil
    }

    public var baseURL: String {
        return "https://mik.qa.platform.michaels.com/api/pubtool"
    }

    public var path: String {
        switch self {
        case .topicSubscribe: return "/notify/topic/subscribe"
        case .fcmTokenChange: return "/notify/fcmToken/change"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .topicSubscribe, .fcmTokenChange:
            return .post
        }
    }

    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .topicSubscribe:
            return JSONEncoding.default
        case .fcmTokenChange:
            return URLEncoding.default

        }
    }

    public var headers: HTTPHeaders? {
        var headers = HTTPHeaders([])
        switch self {
        case .topicSubscribe:
            headers.update(HTTPHeader.contentTypeJSON())

        case .fcmTokenChange:
            headers.update(HTTPHeader.contentTypeForm())
        }

        return headers
    }
}


