//
//  TestWishlistsRequestViewController.swift
//  MikCore_Example
//
//  Created by CY on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import HandyJSON
import MikCore
import UIKit

class TestCPMRequestViewController: MikBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // MARK: - --- 标准格式, data类型为Int ----
//        cpm_provider.requestModel(target: .getFreeShippingThreshold, model: Int.self) { result in
//            switch result {
//            case .success(let res):
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        // MARK: - --- 标准格式, data类型为Int ----
        let body = ["areaCode": "US", "chosenShippingMethodType": "STANDARD_GROUND", "michaelsStoreId": "8847", "shippingItemInfoList": [["amount": 0.28999999999999998, "quantity": "1", "skuNumber": "10656604", "price": 0.28999999999999998]]] as [String : Any]
        cpm_provider.requestModelMap(target: .checkoutSummary, model: SameDayDelivery.self, body: body) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
    }
}

