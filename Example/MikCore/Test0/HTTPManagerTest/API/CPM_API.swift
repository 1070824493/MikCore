//
//  RECOMMENDATION_API.swift
//  MikCore_Example
//
//  Created by m7 on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MikCore
import Alamofire


let cpm_provider = HTTPManager<CPM_API>()

enum CPM_API {
    case getFreeShippingThreshold
    case checkoutSummary
}

extension CPM_API : HTTPTarget {
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var baseURL: String {
        return "https://mik.dev.platform.michaels.com"
    }
    var rootPath: String? {
        return "/api/cpm"
    }

    var path: String {
        switch self {
        case .getFreeShippingThreshold: return "/shipping/getFreeShippingThreshold/US"
        case .checkoutSummary: return "/shipping/checkout-summary/same-day-delivery"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getFreeShippingThreshold : return .get
        case .checkoutSummary: return .post
        }
    }

    var headers: HTTPHeaders? {
        var headers = HTTPHeaders([])
        headers.update(HTTPHeader.contentTypeJSON())
        headers.add(.authorization(bearerToken: wish_token))

        return headers
    }

}
