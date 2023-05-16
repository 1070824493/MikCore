//
//  MenuNavTreeModel.swift
//  MikCore_Example
//
//  Created by zhenrong on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON

struct MenuNavTreeModel: HandyJSON {
    var children = [MenuNavTreeChildren]()
    var codePath: String?
    var image: String?
    var isLanding: Bool = false
    var isLeaf: Bool = false
    var parentTaxonomyPath: String?
    var sortBy: String?
    var taxonomyId: Int = 0
    var taxonomyName: String?
    var type: Int = 0
    var url: String?
    var urlCode: String?
    var urlPath: String?
    var urlTaxonomyName: String?
}

struct MenuNavTreeChildren: HandyJSON {
    var children = [String]()
    var codePath: String?
    var image: String?
    var isLanding: Bool = false
    var isLeaf: Bool = false
    var parentTaxonomyPath: String?
    var sortBy: Int = 0
    var taxonomyId: Int = 0
    var taxonomyName: String?
    var type: Int = 0
    var url: String?
    var urlCode: String?
    var urlPath: String?
    var urlTaxonomyName: String?
}
