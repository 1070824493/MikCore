//
//  SearchReturnBuyerList.swift
//
//
//  Created by JSONConverter on 2022/04/26.
//  Copyright © 2022年 JSONConverter. All rights reserved.
//  JSONConverter 自动生成

import Foundation
import HandyJSON

struct SearchReturnBuyerListModel: HandyJSON {
    var aggregate: String?
    var content = [SearchReturnBuyerListDataContent]()
    var empty: Bool = false
    var first: Bool = false
    var last: Bool = false
    var number: Int = 0
    var numberOfElements: Int = 0
    var pageable: SearchReturnBuyerListDataPageable?
    var size: Int = 0
    var sort: SearchReturnBuyerListDataSort?
    var totalElements: String?
    var totalPages: Int = 0
}

struct SearchReturnBuyerListDataContent: HandyJSON {
    var anonymous: Bool = false
    var createdTime: String?
    var customerEmail: String?
    var customerName: String?
    var id: String?
    var itemCount: Int = 0
    var orderNumber: String?
    var parentOrderNumber: String?
    var refundAmount: Float = 0.0
    var refundCommissionFee: Float = 0.0
    var refundedProcessingFee: Int = 0
    var refundedShippingCommissionFee: Int = 0
    var refundShippingHandlingFee: Float = 0.0
    var refundShippingHandlingTax: Int = 0
    var refundTax: Float = 0.0
    var returnOrderNumber: String?
    var status: Int = 0
    var thumbnail = [String]()
    var userId: String?
    var userType: Int = 0
}

struct SearchReturnBuyerListDataSort: HandyJSON {
    var empty: Bool = false
    var sorted: Bool = false
    var unsorted: Bool = false
}

struct SearchReturnBuyerListDataPageable: HandyJSON {
    var offset: String?
    var paged: Bool = false
    var pageNumber: Int = 0
    var pageSize: Int = 0
    var sort: SearchReturnBuyerListDataPageableSort?
    var unpaged: Bool = false
}

struct SearchReturnBuyerListDataPageableSort: HandyJSON {
    var empty: Bool = false
    var sorted: Bool = false
    var unsorted: Bool = false
}
