//
//  CMS_API.swift
//  MikCore_Example
//
//  Created by ty on 2022/5/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MikCore
import Alamofire

public let providerCMS = HTTPManager<CMS_API>()

public enum CMS_API {
    case voteV2
}

extension CMS_API : HTTPTarget {
    public var baseURL: String {
        return "https://mik.dev.platform.michaels.com"
    }

    public var rootPath: String? {
        return "/api/cms"
    }

    public var path: String {
        return "/v2/vote"
    }

    public var method: HTTPMethod {
        return .put
    }

    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }

    public var headers: HTTPHeaders? {
        switch self {

        case .voteV2:
            var header = HTTPHeaders.mikDefault
            header.update(.contentTypeJSON())
            return header
        }


    }


}
