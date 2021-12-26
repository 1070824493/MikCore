//
//  MikBaseModel.swift
//  Module_Foundation
//
//  Created by ty on 2021/11/25.
//

import Foundation
import HandyJSON

/// 后台标准格式 解析模型
public class MikStandardModel<T>: HandyJSON {
    public required init() {}

    public var code: String?
    public var message: String?
    public var data: T?
    public var datas: [T]?
}
