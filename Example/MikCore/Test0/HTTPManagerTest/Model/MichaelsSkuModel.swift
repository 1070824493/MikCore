//
//  MichaelsSkuModel.swift
//  MikCore_Example
//
//  Created by zhenrong on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON

struct MichaelsSkuModel: HandyJSON {
    var formatted_address: String?
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var sddStores: String?
    var stores = [MichaelsSkuStores]()
}

struct MichaelsSkuStores: HandyJSON {
    var address: String?
    var address2: String?
    var availableQuantity: Int = 0
    var bopis: Bool = false
    var city: String?
    var coords_latitude: Float = 0.0
    var coords_longitude: Float = 0.0
    var country: String?
    var created_time: String?
    var curbside_pickup: Bool = false
    var curbside_pickup_hours: String?
    var curbside_pickup_zones: String?
    var custom_attributes: String?
    var description: String?
    var distance: Float = 0.0
    var dropoffOffset: String?
    var email: String?
    var fabrics: Bool = false
    var fax: String?
    var geo_hash: String?
    var instore_shopping: Bool = false
    var instorePickupSlaMessage: String?
    var is_express_checkout_enabled: Bool = false
    var isStoreOpened: Bool = false
    var jetLagMinutes: String?
    var michaels_store_id: Int = 0
    var michaels_store_name: String?
    var minted_appointment_url: String?
    var minted_opt_in: Bool = false
    var pickupInStoreMessage: String?
    var pickupOffset: String?
    var pickupOffsetReadyForPickup: String?
    var prototype_stores: Bool = false
    var region_code: String?
    var roadieApiKey: String?
    var same_day_delivery: Bool = false
    var scan_and_go_enabled: Bool = false
    var state: String?
    var status: Bool = false
    var store_business_hours: String?
    var store_closing_dates: String?
    var storeCloseOffset: String?
    var storeCloseTime: String?
    var storeOpenTime: String?
    var telephone: String?
    var timeZone: String?
    var updated_time: String?
    var zip_code: String?
}
