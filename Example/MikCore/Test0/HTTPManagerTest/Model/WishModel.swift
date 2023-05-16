//
//  WishModel.swift
//  MikCore_Example
//
//  Created by CY on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON

// MARK: - WishListElement
struct Wish: HandyJSON {
    var listId: String?
    var userId: String?
    var listType: String?
    var listName: String?
    var listTags: String?
    var sortNum: Int?
    var wishListDescription: String?
    var isDefault: Int?
    var isPublic: Int?
    var channel: Int?
    var sharePermissions: Int?
    var createUtcTime: String?
    var updateUtcTime: String?
    var itemsCount: Int?
    var share: Bool?
}
