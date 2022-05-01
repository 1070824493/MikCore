//
//  MikBaseModel.swift
//  Module_Foundation
//
//  Created by ty on 2021/11/25.
//

import Foundation
import HandyJSON

/// 后台标准格式 解析模型
public struct MikStandardModel<T: HandyJSON>: HandyJSON {
    public init() {}

    public var code: String?
    public var message: String?
    public var data: T?
    public var datas: [T]?

    public var isSuccess: Bool {
        if let code = code {
            return businessSuccessCode.contains(code)
        }else{
            return false
        }
    }

    public var isDataEmpty: Bool {
        return data == nil && datas == nil
    }
}


/// 空模型, data为空时使用
public struct MikEmptyModel: HandyJSON {
    public init() {}
}

/// 基础类型扩展Model支持
extension String : HandyJSON { }
extension Int : HandyJSON { }
extension Float : HandyJSON { }
extension Double : HandyJSON { }
extension Bool : HandyJSON { }

