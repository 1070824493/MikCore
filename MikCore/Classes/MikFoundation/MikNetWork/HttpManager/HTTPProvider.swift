//
//  HTTPProvider.swift
//  MikCore
//
//  Created by ty on 2022/4/26.
//

import Foundation
import HandyJSON
import Alamofire

public protocol HTTPProvider: AnyObject {
    associatedtype Target: HTTPTarget

    func requestModel<M: HandyJSON>(target: Target, model: M.Type, parameters: [String : Any]?, body: Any?, callback: @escaping MikRequestModelHandler<M>) -> DataRequest?

    func requestSwiftyJSON(target: Target, parameters: [String : Any]?, body: Any?, callback: @escaping MikRequestJSONHandler) -> DataRequest?


    //MARK: ---- 下面的方法等后台统一之后删除 ----
    func requestModelArray<M: HandyJSON>(target: Target, model: M.Type, parameters: [String : Any]?, body: Any?, callback: @escaping MikRequestModelHandler<M>) -> DataRequest?

    func requestModelMap<M: HandyJSON>(target: Target, model: M.Type, parameters: [String : Any]?, body: Any?, callback: @escaping MikRequestModelHandler<M>) -> DataRequest?
}
