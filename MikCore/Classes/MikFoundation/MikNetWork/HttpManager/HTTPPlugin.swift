//
//  HTTPPlugin.swift
//  MikCore
//
//  Created by user on 2022/5/11.
//

import Alamofire
import Foundation
import SwiftyJSON

public protocol HTTPPlugin {
    // 构造request
    func prepare(_ request: inout URLRequest)

    // 将要发出request
    func willSend(_ request: DataRequest?)

    // 收到response
    func didReceive(_ request: DataRequest?, result: Result<JSON?, MikError>)
}

public extension HTTPPlugin {
    func prepare(_ request: inout URLRequest) {}

    func willSend(_ request: DataRequest?) {}

    func didReceive(_ request: DataRequest?, result: Result<JSON?, MikError>) {}
}
