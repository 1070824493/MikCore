//
//  TestQAAPIViewController.swift
//  MikCore_Example
//
//  Created by m7 on 2022/4/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import HandyJSON

class TestQAAPIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        /**
        let retailApi: QA_API = .cofactordigital(.retail(id: "495dca5c0cde6302"))

//        storeref=1082&limit=100&languageid=1&require=FeaturedDepartment
        var params = [String: Any]()
        params["storeref"] = "1082"
        params["limit"] = 100
        params["languageid"] = 1
        params["require"] = "FeaturedDepartment"
        
        providerQA.requestModelMap(target: retailApi, model: RetailModel.self, parameters: params, body: nil) { rs in
            switch rs {
            case .success(let res):
                assert(res.isSuccess, "failure: \(retailApi.path)")
            case .failure(let err):
                print(err)
            }
        }
         */
                
        
        let retailApi: QA_API = .cofactordigital(.retail(id: "495dca5c0cde6302"))

//        storeref=1082&departmentid=5209532&languageid=1&sort=1&limit=100
        var params = [String: Any]()
        params["storeref"] = "1082"
        params["limit"] = 100
        params["languageid"] = 1
        params["departmentid"] = "5209532"
        params["sort"] = 1
        
        providerQA.requestModelMap(target: retailApi, model: RetailModel.self, parameters: params, body: nil) { rs in
            switch rs {
            case .success(let res):
                assert(res.isSuccess, "failure: \(retailApi.path)")
            case .failure(let err):
                print(err)
            }
        }
        
    }

}


struct RetailModel: HandyJSON {
    var contentDate: String?
    var contentDateString: String?
    var exception: String?
    var results = [RootClassResults]()
    var totalCount: Int = 0
}

struct RootClassResults: HandyJSON {
    var description: String?
    var displayOrder: Int = 0
    var id: Int = 0
    var listingCount: Int = 0
}

