//
//  SCH_API.swift
//  MikCore_Example
//
//  Created by zhenrong on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MikCore
import Alamofire


let providerSCH = HTTPManager<SCH_API>()

enum SCH_API {
    case products
    case categoryLandingPageJson
    case michaelsMenuNavTree
    case suggest
}

extension SCH_API : HTTPTarget {
    var rootPath: String? {
        return nil
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .products:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }

    var baseURL: String {
        switch self {
        case .categoryLandingPageJson:
            return "https://mik01.dev.platform.michaels.com/released-template"
        case .michaelsMenuNavTree:
            return "https://mik01.dev.platform.michaels.com/released-menu"
        default:
            return "https://mik.dev.platform.michaels.com/api/sch"
        }
    }

    var path: String {
        switch self {
        case .products:
            return "/search/michaels/products"
        case .categoryLandingPageJson:
            return "/CategoryLandingPage_US_Mobile_michaels.com.json"
        case .michaelsMenuNavTree:
            return "/michaels_menu_nav_tree.json"
        case .suggest:
            return "/search/michaels/suggest"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .products:
            return .post
        default:
            return .get
        }
    }

    var headers: HTTPHeaders? {

        var headers = HTTPHeaders([])
//        switch self {
//        default:
            headers.update(HTTPHeader.accept("*/*"))
//        }

        return headers
    }


}




let providerStoreLocator = HTTPManager<Store_Locator_API>()

enum Store_Locator_API {
    case michaelsStoreId
    case sddStoresByZipCode
    case skuAddress
}

extension Store_Locator_API : HTTPTarget {
    var rootPath: String? {
        return nil
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }

    var baseURL: String {
        switch self {
        default:
            return "https://mik.dev.platform.michaels.com/api"
        }
    }

    var path: String {
        switch self {
        case .michaelsStoreId:
            return "/store-locator/store"
        case .sddStoresByZipCode:
            return "/store-locator/sdd-stores-by-zipcode"
        case .skuAddress:
            return "/store-locator/sku-address"
        }
    }

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var headers: HTTPHeaders? {

        var headers = HTTPHeaders([])
//        switch self {
//        default:
            headers.update(HTTPHeader.accept("*/*"))
//        }

        return headers
    }


}
