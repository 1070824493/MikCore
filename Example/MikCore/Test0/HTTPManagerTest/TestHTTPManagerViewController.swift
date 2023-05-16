//
//  TestHttpManagerViewController.swift
//  MikCore_Example
//
//  Created by ty on 2022/4/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import HandyJSON
import MikCore
import UIKit

struct TestModel: HandyJSON {
    var publicKey: String?
    var serverTime: String?
}

class TestHTTPManagerViewController: MikBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()


        let param = ["ratingReviewReplyType": "REVIEW", "voteType": "POSITIVE"]
        let body = ["userId": "string", "entityId": "string"]
        providerCMS.requestSwiftyJSON(target: .voteV2, parameters: param, body: body) { result in
            switch result {

            case .success(let res):
                print(res)
            case .failure(let error):
                print(error)
            }
        }

        // ePMFyxjZJksbhg68-h6y2q:APA91bEG3ViUftZzSxC7aw0nZvVlD4W63NN6sHP8mTs3ppdit50SOhR5cqPo6kJLUvC4SI9WqFfPIvw6rDJu8zs1x-U9zJRR_UHUubapwd4n67qkCr4Yp-EaA9IuY5eYlYAjDAi-pbLJ

        // 样例: 传入错误的参数,每隔5秒重试3次 Post请求 JSON Encode, 返回空的标准模型
//        pubtoolProvider.requestModel(target: .topicSubscribe, model: MikEmptyModel.self, body: ["fcmToken" : "f_dgtvbuzUHFg_lP1vSBcy:APA91bFVOQkeO47-rXZXlTtsHBbTeWouZHJ5HvjhUPpcaNAhD4MkAPRFzlTZJe1hNKxi37980pvKaVRwF-nnkkzVAOHlnjKORMTXuRIKU0jHxlh0uRHPXH8S3NmO9HS2KEVOYWiJkyq-", "topic": "all"]) { result in
//            switch result {
//
//            case .success(let response):
//                print(response)
//                break
//            case .failure(let error):
//                print(error)
//                break
//            }
//        }

//        providerPubtool.requestModel(target: .conversation(.fcmTokenChange), model: MikEmptyModel.self, parameters: ["oldFcm" : "test1", "newFcm" : "test2"]) { result in
//            switch result {
//            case .success(let response):
//                print(response)
//                break
//            case .failure(let error):
//                print(error)
//                break
//            }
//        }

        // 样例: 标准格式 自定义解析模型
//        usrProvider.requestModel(target: .getPublicKey, model: GetPublickKeyModel.self) { result in
//            switch result {
//            case .success(let response):
//                print(response)
//                break
//            case .failure(let error):
//                print(error)
//                break
//            }
//        }

        // MARK: - --- 非标准格式,字符串解析 ----

//        providerFIN.requestSwiftyJSON(target: .getBraintreeToken) { result in
//            switch result {
//
//            case .success(let json):
//                print(json.string)
//            case .failure(let error):
//                print(error)
//                break
//            }
//        }

        // MARK: - --- 标准格式,不解析模型 ----

//        providerUSR.requestSwiftyJSON(target: .getPublicKey) { result in
//            switch result {
//
//            case .success(let json):
//                print(json.dictionaryObject)
//            case .failure(let error):
//                print(error)
//                break
//            }
//        }

        // MARK: - --- 标准格式,多级模型解析 ----

//        provider_moh_rsc.requestModel(target: .searchReturnBuyerList, model: SearchReturnBuyerListModel.self, parameters: ["type": 2, "pageNum": 1, "pageSize": 10]) { result in
//            switch result {
//            case .success(let res):
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }

        // MARK: - --- 非标准格式,数组模型解析 ----

//        providerFIN.requestModelArray(target: .wallet(.getWalletBankcard("528865150424997")), model: String.self) { result in
//            switch result {
//            case .success(let res):
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }

        // MARK: - --- 非标准格式, 字典模型解析 ----

//        providerFIN.requestModelMap(target: .wallet(.getWalletBankcardId("5978143882427121664")), model: WalletBankcardListModel.self) { result in
//            switch result {
//            case .success(let res):
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }

        // MARK: - --- 非标准格式, post传参, 数组模型解析 ----

//        {
//            "bankCardNickName": "Ying1",
//            "holderName": "Discover",
//            "bankCardId": "53427543869177857",
//            "defaultCard": 1,
//            "user": {
//                "ownerType": "1",
//                "userId": "36029157816396877"
//            },
//            "expirationDate": "1223"
//        }
//        let body = WalletUpdateRequestModel.init(bankCardId: "53427543869177857", bankCardNickName: "Ying2", defaultCard: 1, expirationDate: "1223", holderName: "Discover", user: WalletUpdateRequestModelUser(ownerType: "1", userId: "36029157816396877")).toJSON()
//        providerFIN.requestModelArray(target: .wallet(.walletUpdate), model: WalletBankcardListModel.self, body: body) { result in
//            switch result {
//            case .success(let res):
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }

        // MARK: - --- 非标准格式, delete传参,数组模型解析 ----

//        let body = ["bankCardId" : "53858037031190529", "userId": "36029157816396877"]
//        providerFIN.requestModelArray(target: .wallet(.walletDelete), model: WalletBankcardListModel.self, body: body) { result in
//            switch result {
//            case .success(let res):
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }

        // MARK: - --- 非标准格式, get,数组模型解析 ----

//        providerFIN.requestModelArray(target: .wallet(.getGiftCard("528865150424997")), model: GiftCardModel.self) { result in
//            switch result {
//            case .success(let res):
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }

        // MARK: - --- 非标准格式, delete传参,返回空数组 ----

//        let body = ["giftCardId" : "53487952584196096", "userId": "36029157816396877"]
//        providerFIN.requestModelArray(target: .wallet(.giftCardDelete), model: WalletBankcardListModel.self, body: body) { result in
//            switch result {
//            case .success(let res):
//                print(res)
//            case .failure(let error):
//                print(error)
//            }
//        }


        //MARK: ---- 非标准格式, post 返回map ----
//        let body = [
//            "order": 0,
//            "pageNumber": 1,
//            "pageSize": 8
//        ]
//
//        providerFGM.requestModelMap(target: .product(.moreProducts("5353773113534988288")), model: MoreProductModel.self, body: body) { result in
//            switch result {
//                case .success(let res):
//                    print(res)
//                case .failure(let error):
//                    print(error)
//            }
//        }
    }
}
