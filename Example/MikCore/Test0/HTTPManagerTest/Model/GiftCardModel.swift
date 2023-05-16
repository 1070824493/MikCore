//
//  GiftCardModel.swift
//
//
//  Created by JSONConverter on 2022/04/27.
//  Copyright © 2022年 JSONConverter. All rights reserved.
//

import Foundation
import HandyJSON

struct GiftCardModel: HandyJSON {
    var AddedTime: String?
    var balance: String?
    var currency: String?
    var defaultCard: Int = 0
    var encryptedGiftCardNum: String?
    var encryptedGiftCardPin: String?
    var giftCardId: String?
    var giftCardNickname: String?
    var giftCardTailNum: String?
    var ownerType: Int = 0
    var status: Int = 0
}
