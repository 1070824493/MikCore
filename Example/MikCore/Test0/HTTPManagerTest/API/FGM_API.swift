//
//  FGM_API.swift
//  MikCore_Example
//
//  Created by ty on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MikCore
import Alamofire

//调度实例
let providerFGM = HTTPManager<FGM_API>()

//MARK: ---- FGM_API 结构枚举 ----
public enum FGM_API  {
    case product(Product_API)

    //MARK: ---- FGM_API 子模块 结构枚举 ----
    public enum Product_API {
        case moreProducts(String)
        case similarProduct
        case shippingOptions
    }
}

//MARK: ---- 子模块 协议实现 ----
extension FGM_API.Product_API: HTTPTarget {
    public var baseURL: String {
        return "https://mik.dev.platform.michaels.com/api/fgm"
    }

    public var rootPath: String? {
        return nil
    }
    public var path: String {
        switch self {

        case .moreProducts(let str): return "/product/\(str)/moreProducts"
        case .similarProduct: return "/recommendation/similarProduct"
        case .shippingOptions: return "/shipping/options"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .similarProduct, .shippingOptions: return .get
        case .moreProducts: return .post
        }
    }

    public var parameterEncoding: ParameterEncoding {
        switch self {

        default:
            return JSONEncoding.default
        }
    }

    public var headers: HTTPHeaders? {
        var headers = HTTPHeaders([])
        headers.update(HTTPHeader.contentTypeJSON())
        return headers
    }


}

//MARK: ---- 主模块 通用扩展配置 ----

extension FGM_API : HTTPTarget{
    public var parameterEncoding: ParameterEncoding {
        return value.parameterEncoding
    }

    public var baseURL: String {
        return value.baseURL
    }

    public var rootPath: String? {
        return nil
    }

    public var path: String {
        return value.path
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

fileprivate extension FGM_API {
    var value : HTTPTarget {
        switch self {
        case .product(let product): return product
        }
    }
}


