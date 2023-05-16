//
//  FIN_API.swift
//  MikCore_Example
//
//  Created by ty on 2022/4/26.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MikCore
import Alamofire


let providerFIN = HTTPManager<FIN_API>()


public enum FIN_API {
    case braintree(Braintree_API)
    case wallet(Wallet_API)
}

public enum Wallet_API {
    case getWalletBankcard(String)
    case getWalletBankcardId(String)
    case walletUpdate
    case walletDelete
    case getGiftCard(String)
    case giftCardDelete
}

public enum Braintree_API {
    case getBraintreeToken
}

extension Wallet_API : HTTPTarget {
    public var parameterEncoding: ParameterEncoding {
        switch self {

        default:
            return JSONEncoding.default
        }
    }

    public var baseURL: String {
        return "https://mik.tst.platform.michaels.com/api/fin"
    }
    public var rootPath: String? {
        return nil
    }

    public var path: String {
        switch self {
        
        case .getWalletBankcard(let str): return "/wallet/bankcard/\(str)"
        case .getWalletBankcardId(let str): return "/wallet/bankCardId/\(str)"

        case .walletUpdate: return "/wallet/update"
        case .walletDelete: return "/wallet/delete"
        case .getGiftCard(let str): return "/wallet/gift-card/\(str)"
        case .giftCardDelete: return "/wallet/gift-card/delete"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getWalletBankcard, .getWalletBankcardId, .getGiftCard : return .get

        case .walletUpdate: return .post
        case .walletDelete, .giftCardDelete: return .delete

        }
    }

    public var headers: HTTPHeaders? {

        var headers = HTTPHeaders([])
        headers.update(HTTPHeader.contentTypeJSON())
        return headers
    }


}

extension Braintree_API : HTTPTarget {
    public var parameterEncoding: ParameterEncoding {
        switch self {

        default:
            return JSONEncoding.default
        }
    }

    public var baseURL: String {
        return "https://mik.tst.platform.michaels.com/api/fin"
    }

    public var rootPath: String? {
            return nil
    }

    public var path: String {
        switch self {
        case .getBraintreeToken: return "/braintree/token"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getBraintreeToken: return .get

        }
    }

    public var headers: HTTPHeaders? {

        var headers = HTTPHeaders([])
        headers.update(HTTPHeader.contentTypeJSON())
//        headers.add(.authorization(bearerToken: testToken))
        return headers
    }


}

//MARK: ---- 为服务端API 扩展子模块 ----
extension FIN_API : HTTPTarget{
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

fileprivate extension FIN_API {
    var value : HTTPTarget {
        switch self {

        case .braintree(let v):
            return v
        case .wallet(let v):
            return v
        }
    }
}
