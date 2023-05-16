//
//  WalletUpdateRequestModel.swift
//
//
//  Created by JSONConverter on 2022/04/26.
//  Copyright © 2022年 JSONConverter. All rights reserved.
//

import Foundation
import HandyJSON

struct WalletUpdateRequestModel: HandyJSON {
    var bankCardId: String?
    var bankCardNickName: String?
    var defaultCard: Int = 0
    var expirationDate: String?
    var holderName: String?
    var user: WalletUpdateRequestModelUser?
}

struct WalletUpdateRequestModelUser: HandyJSON {
    var ownerType: String?
    var userId: String?
}
