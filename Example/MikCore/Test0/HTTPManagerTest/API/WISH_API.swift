//
//  WISH_API.swift
//  MikCore_Example
//
//  Created by CY on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MikCore
import Alamofire

let wish_token = "eyJhbGciOiJIUzUxMiJ9.eyJjbGllbnRJZCI6InVzciIsIl91c2VySWQiOiI2NTIwMTA0MDU4MTU5MjkiLCJfc2VsbGVyU3RvcmVJZCI6bnVsbCwiX2RldmljZVV1aWQiOiI4NDZCNDQ1Qi1CNDRCLTQyRkEtODE5MC0yODhGQTY5ODIxQTAiLCJfZGV2aWNlTmFtZSI6bnVsbCwiX2NyZWF0ZVRpbWUiOiIxNjUxMDM4MzE0MzIwIiwiX2V4cGlyZVRpbWUiOiIxNjUzNjMwMzE0MzIwIiwic3ViIjoiNjUyMDEwNDA1ODE1OTI5IiwiaWF0IjoxNjUxMDM4MzE0LCJleHAiOjE2NTM2MzAzMTQsImF1ZCI6InVzZXIifQ.oQ0Kl9Yz1m3bcC2Rm2TSOLBdMP892SVpZF3zRJ608KTXOFkDmw6eBKhTMNBzOYjhl2TxdOy9MdGX7aN_mI3JKA"

let wish_provider = HTTPManager<WISH_API>()


enum WISH_API {
    case wishlists(String)
    case updateSharePermissions(String)
    case myWishList
    case shareWishList(String)
    case wishListItems(String)
}

extension WISH_API : HTTPTarget {
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
//        switch self {
//        case .wishlists(_):
//            return URLEncoding.default
//        }
    }

    var baseURL: String {
        return "https://mik.dev.platform.michaels.com"
    }

    var rootPath: String? {
        return nil
    }

    var path: String {
        switch self {
        case .wishlists(let id): return "/api/wishlists/\(id)"
        case .updateSharePermissions(let id): return "/api/wishlists/\(id)/updateSharePermissions"
        case .myWishList: return "/api/wishlists"
        case .shareWishList(let id): return "/api/wishlists/\(id)/email-list-share-invitation-V2"
        case .wishListItems(let id): return "/api/wishlists/\(id)/wishlist-items"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .wishlists(_) : return .put
        case .updateSharePermissions(_): return .put
        case .myWishList: return .get
        case .shareWishList(_): return .post
        case .wishListItems(_): return .get
        }
    }

    var headers: HTTPHeaders? {

        var headers = HTTPHeaders([])
//        switch self {
//        default:
//            headers.update(HTTPHeader.contentTypeJSON())
//            headers.add(.authorization(bearerToken: testToken))
//        }
        headers.update(HTTPHeader.contentTypeJSON())
        headers.add(.authorization(bearerToken: wish_token))

        return headers
    }


}

