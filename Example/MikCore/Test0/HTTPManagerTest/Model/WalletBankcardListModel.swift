//
//  WalletBankcardListModel.swift
//
//
//  Created by JSONConverter on 2022/04/26.
//  Copyright © 2022年 JSONConverter. All rights reserved.
//

import Foundation
import HandyJSON

struct WalletBankcardListModel: HandyJSON {
    var addressLine1: String?
    var addressLine2: String?
    var bankCardId: String?
    var bankCardNickName: String?
    var cardChannelType: Int = 0
    var cardHolderName: String?
    var cardRefNum: String?
    var city: String?
    var countryId: String?
    var defaultCard: Int = 0
    var expirationDate: String?
    var firstName: String?
    var lastName: String?
    var ownerId: String?
    var ownerType: Int = 0
    var state: String?
    var tailNumber: String?
    var telephone: String?
    var zipCode: String?
}
