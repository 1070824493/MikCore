//
//  MOH-RSC.swift
//  MikCore_Example
//
//  Created by ty on 2022/4/26.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MikCore
import Alamofire


let providerMOH_RSC = HTTPManager<MOH_RSC_API>()

let testToken = "eyJhbGciOiJIUzUxMiJ9.eyJjbGllbnRJZCI6InVzciIsIl91c2VySWQiOiI0NjEyNjQ1ODkyMDc5MzUwNzU3IiwiX3NlbGxlclN0b3JlSWQiOm51bGwsIl9kZXZpY2VVdWlkIjoiM2JkNzE1MWYtMGJmMy00MDRmLWJmMDItMTE5Yzc0OTY0NWVjIiwiX2RldmljZU5hbWUiOiJpUGhvbmUiLCJfY3JlYXRlVGltZSI6IjE2NTA5NjI4OTg1NTAiLCJfZXhwaXJlVGltZSI6IjE2NTEyMjIwOTg1NTAiLCJzdWIiOiI0NjEyNjQ1ODkyMDc5MzUwNzU3IiwiaWF0IjoxNjUwOTYyODk4LCJleHAiOjE2NTEyMjIwOTgsImF1ZCI6InVzZXIiLCJqdGkiOiIifQ.8gLTAFuvtbvkSvKDf4Zh7mBns9T0aYUNsKuJQ2NTssBCXMlRLnr-aZiNb9asW85nubw60WNeMVJV4TIytFYxIg"

enum MOH_RSC_API {
    case searchReturnBuyerList
}

extension MOH_RSC_API : HTTPTarget {
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .searchReturnBuyerList:
            return URLEncoding.default
        }
    }

    var baseURL: String {
        return "https://mik.qa.platform.michaels.com/api/moh-rsc"
    }

    var rootPath: String? {
        return nil
    }

    var path: String {
        switch self {
        case .searchReturnBuyerList: return "/afterSales/search/return/buyer/list/page"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .searchReturnBuyerList : return .get
        }
    }

    var headers: HTTPHeaders? {

        var headers = HTTPHeaders([])
        switch self {
        case .searchReturnBuyerList :
            headers.update(HTTPHeader.contentTypeJSON())
            headers.add(.authorization(bearerToken: testToken))
        }

        return headers
    }


}
