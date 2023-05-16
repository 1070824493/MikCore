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


public let providerMIK = HTTPManager<MIK_API>()

public enum MIK_API {
    
    case recommendationApi(Recommendation_API)
    
}

fileprivate extension MIK_API {
    
    var value: HTTPTarget {
        switch self {
        case .recommendationApi(let value):
            return value
        }
    }
    
}

extension MIK_API: HTTPTarget {
    
    public var baseURL: String { value.baseURL }
    
    public var path: String { value.path }
    
    public var method: HTTPMethod { value.method }
    
    public var parameterEncoding: ParameterEncoding { value.parameterEncoding }
    
    public var headers: HTTPHeaders? { value.headers }
    
}

public enum Recommendation_API {
    
    case similarItems, similarProjects, fetchRecommendSkusByUrl
    
}


extension Recommendation_API: HTTPTarget {
    
    public var baseURL: String {
        switch self {
        case .similarItems:
            return "https://mik.dev.platform.michaels.com/api"
        case .similarProjects, .fetchRecommendSkusByUrl:
            return "https://mik.tst.platform.michaels.com/api"
        }
    }
    
    public var path: String {
        switch self {
        case .similarItems: return "/recommendation/similar-items"
        case .similarProjects: return "/recommendation/similar-projects"
        case .fetchRecommendSkusByUrl: return "/recommendation/fetchRecommendSkusByUrl"
        }
    }
    
    public var method: HTTPMethod { .get }
    
    public var parameterEncoding: ParameterEncoding { URLEncoding.queryString }
    
    public var headers: HTTPHeaders? { HTTPHeaders.mikDefault }
    
}
