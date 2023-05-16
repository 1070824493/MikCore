//
//  CategoryLandingModel.swift
//  MikCore_Example
//
//  Created by zhenrong on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON

struct CategoryLandingModel: HandyJSON {
    var channel: String?
    var code: String?
    var country: String?
    var createdBy: Int = 0
    var createdTime: CategoryLandingCreatedTime?
    var groupId: String?
    var id: String?
    var lastActiveId: String?
    var lastStatus: String?
    var name: String?
    var pageName: String?
    var parameters: CategoryLandingParameters?
    var platform: String?
    var status: String?
    var updatedBy: Int = 0
    var updatedTime: CategoryLandingUpdatedTime?
    var version: Int = 0
}

struct CategoryLandingParameters: HandyJSON {
    var sections = [CategoryLandingParametersSections]()
}

struct CategoryLandingParametersSections: HandyJSON {
    var compType: String?
    var data: CategoryLandingParametersSectionsData?
    var id: String?
    var title: String?
}

struct CategoryLandingParametersSectionsData: HandyJSON {
    var backgroundUrl: String?
    var cardLayout: String?
    var columns: Int = 0
    var isShowBackgroundColor: Bool = false
    var isShowBtn: Bool = false
    var isShowTitleImg: String?
    var layout: String?
    var list = [CategoryLandingParametersSectionsDataList]()
    var subTitle: String?
    var title: String?
}

struct CategoryLandingParametersSectionsDataList: HandyJSON {
    var fileSize: Int = 0
    var fileType: String?
    var imageUrl: String?
    var title: String?
    var url: String?
    var url_type: String?
}

struct CategoryLandingUpdatedTime: HandyJSON {
    var date: CategoryLandingUpdatedTimeDate?
    var time: CategoryLandingUpdatedTimeTime?
}

struct CategoryLandingUpdatedTimeDate: HandyJSON {
    var day: Int = 0
    var month: Int = 0
    var year: Int = 0
}

struct CategoryLandingUpdatedTimeTime: HandyJSON {
    var hour: Int = 0
    var minute: Int = 0
    var nano: Int = 0
    var second: Int = 0
}

struct CategoryLandingCreatedTime: HandyJSON {
    var date: CategoryLandingCreatedTimeDate?
    var time: CategoryLandingCreatedTimeTime?
}

struct CategoryLandingCreatedTimeDate: HandyJSON {
    var day: Int = 0
    var month: Int = 0
    var year: Int = 0
}

struct CategoryLandingCreatedTimeTime: HandyJSON {
    var hour: Int = 0
    var minute: Int = 0
    var nano: Int = 0
    var second: Int = 0
}
