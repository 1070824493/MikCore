//
//  CPMModel.swift
//  MikCore_Example
//
//  Created by CY on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON

struct SameDayDelivery: HandyJSON {
    var statusCode: String?
    var statusMessage: String?
    var sameDayDeliveryFee: String?
    var sameDayDeliverySku: String?
}
