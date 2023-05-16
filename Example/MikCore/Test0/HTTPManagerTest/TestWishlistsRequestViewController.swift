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

class TestWishlistsRequestViewController: MikBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - --- 非标准格式,数组模型解析 ----
//        let body = ["listName": "Wish List", "isDefault": 0, "isPublic": 0, "listTags": "", "description": "YOU Are"] as [String : Any]
//        wish_provider.requestModelArray(target: .wishlists("5707061008586653697"), model: Wish.self, body: body) { result in
//            switch result {
//            case .success(let res):
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        //    https://mik.tst.platform.michaels.com/api/wishlists?userId=360804708437
//        let parameters = ["userId": "5707061008586653697"] as [String : Any]
//        wish_provider.requestModelArray(target: .myWishList, model: Wish.self, parameters: parameters) { result in
//            switch result {
//            case .success(let res):
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        // MARK: - --- 非标准格式,HandJson解释Bool类型 ----
        wish_provider.requestModelArray(target: .wishListItems("5707061008586653697"), model: Wish.self) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }
        
        // MARK: - --- 非标准格式,Map模型解析 ----
        // "SHARED" : "PRIVATE"
//        wish_provider.requestModelMap(target: .updateSharePermissions("5707061008586653697"), model: Wish.self, body: "SHARED") { result in
//            switch result {
//            case .success(let res):
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        

    }
}

