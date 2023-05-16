//
//  MoreProductModel.swift
//
//
//  Created by JSONConverter on 2022/04/27.
//  Copyright © 2022年 JSONConverter. All rights reserved.
//

import Foundation
import HandyJSON

struct MoreProductModel: HandyJSON {
    var pageInfo: String?
    var productResponses = [MoreProductModelProductResponses]()
}

struct MoreProductModelProductResponses: HandyJSON {
    var averageRating: Int = 0
    var channel: Int = 0
    var createdTime: String?
    var itemName: String?
    var itemStatus: Int = 0
    var price: Int = 0
    var productId: String?
    var sellerStoreId: String?
    var shipping: MoreProductModelProductResponsesShipping?
    var skuDisplayName: String?
    var skuName: String?
    var skuNumber: String?
    var sortedPrice = [Int]()
    var storeName: String?
    var thumbnailUrl: String?
    var totalOfRating: Int = 0
    var updateDatetime: String?
    var variants = [String]()
}

struct MoreProductModelProductResponsesShipping: HandyJSON {
    var handlingRate: Int = 0
}
