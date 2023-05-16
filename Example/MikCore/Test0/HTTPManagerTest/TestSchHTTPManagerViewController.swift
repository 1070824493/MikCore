//
//  TestSchHTTPManagerViewController.swift
//  MikCore_Example
//
//  Created by zhenrong on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

class TestSchHTTPManagerViewController: MikBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        testSuggest()
//        testCategoryLandingPageJson()
//        testMichaelsMenuNavTreeJson()
//        testSkuAddress()
//        testProducts()
//        testSddStoresByZipCode()
        testStoreId()
    }
}

extension TestSchHTTPManagerViewController {
    
    func testStoreId() {
        let param: [String: Any] = [
            "michaelsStoreId": 1056,
        ]
        let target: Store_Locator_API = .michaelsStoreId
        providerStoreLocator.requestSwiftyJSON(target: target, parameters: param) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
        providerStoreLocator.requestModelMap(target: target, model: MichaelsStoreModel.self, parameters: param) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func testSddStoresByZipCode() {
        let param: [String: Any] = [
            "range": 10,
            "zipCode": 75382
        ]
        let target: Store_Locator_API = .sddStoresByZipCode
        providerStoreLocator.requestSwiftyJSON(target: target, parameters: param) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
        providerStoreLocator.requestModelMap(target: target, model: MichaelsSkuModel.self, parameters: param) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func testSuggest() {
        providerSCH.requestModelArray(target: .suggest, model: String.self, parameters: ["userInput": "A"]) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func testCategoryLandingPageJson() {
        providerSCH.requestModelMap(target: .categoryLandingPageJson, model: CategoryLandingModel.self) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func testMichaelsMenuNavTreeJson() {
        providerSCH.requestModelMap(target: .michaelsMenuNavTree, model: MenuNavTreeModel.self) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func testSkuAddress() {
        let param: [String: Any] = [
            "address": "75063",
            "channel": 1,
            "latitude": 0,
            "longitude": 0,
            "range": 20,
            "skuNumber": ""
        ]
        let target: Store_Locator_API = .skuAddress
        providerStoreLocator.requestSwiftyJSON(target: target, parameters: param) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
//        providerStoreLocator.requestModel(target: target, model: MichaelsSkuModel.self, parameters: param) { result in
//            switch result {
//            case .success(let res):
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }
        providerStoreLocator.requestModelMap(target: target, model: MichaelsSkuModel.self, parameters: param) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func testProducts() {
        let param: [String: Any] = [
            "maxPrice": 1000000000,
            "keywords": "B",
            "maxRating": 5,
            "pageSize": 10,
            "pageNumber": 0,
            "minPrice": 0,
            "minRating": 0,
            "toAggregate": 1
        ]
        providerSCH.requestSwiftyJSON(target: .products, parameters: param) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
        providerSCH.requestModel(target: .products, model: MichaelsProductModel.self, parameters: param) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
        providerSCH.requestModelMap(target: .products, model: MichaelsProductModel.self, parameters: param) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
    }
}
