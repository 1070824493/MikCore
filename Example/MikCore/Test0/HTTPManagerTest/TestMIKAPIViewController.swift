//
//  TestMIKAPIViewController.swift
//  MikCore_Example
//
//  Created by m7 on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import HandyJSON


extension Recommendation_API {    
    
    var params: [String: Any]? {
        switch self {
        case .similarItems:
//            targetItemId=10264853&candidate-count=12&same-label-percent=0.6
            var pms = [String: Any]()
            pms["targetItemId"] = "10264853"
            pms["candidate-count"] = 12
            pms["same-label-percent"] = 0.6
            return pms
            
        case .similarProjects:
//            externalId=B_49431&candidate-count=5
            var pms = [String: Any]()
            pms["externalId"] = "B_49431"
            pms["candidate"] = 5
            return pms
            
        case .fetchRecommendSkusByUrl:
//            urlPath=michaels/popular_sale_item&candidate_count=18&user_id=36029157816396877
            var pms = [String: Any]()
            pms["urlPath"] = "michaels/popular_sale_item"
            pms["candidate_count"] = 1
            pms["user_id"] = "36029157816396877"
            return pms
        }
    }
    
}

class TestMIKAPIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let similarItemsApi: Recommendation_API = .similarItems
        providerMIK.requestModelArray(target: MIK_API.recommendationApi(similarItemsApi), model: SimilarItemsModel.self, parameters: similarItemsApi.params) { rs in
            switch rs {
            case .success(let res):
                assert(res.isSuccess, "failure: \(similarItemsApi.path)")
            case .failure(let err):
                print(err)
            }
        }
        
        let similarProjectsApi: Recommendation_API = .similarProjects
        providerMIK.requestModelArray(target: MIK_API.recommendationApi(similarProjectsApi), model: String.self, parameters: similarProjectsApi.params) { rs in
            switch rs {
            case .success(let res):
                assert(res.isSuccess, "failure: \(similarProjectsApi.path)")
            case .failure(let err):
                print(err)
            }
        }

        let skusByUrlApi = Recommendation_API.fetchRecommendSkusByUrl
        providerMIK.requestModelArray(target: MIK_API.recommendationApi(skusByUrlApi), model: String.self, parameters: skusByUrlApi.params) { rs in
            switch rs {
            case .success(let res):
                assert(res.isSuccess, "failure: \(skusByUrlApi.path)")
            case .failure(let err):
                print(err)
            }
        }
    }
    
}




struct SimilarItemsModel: HandyJSON {
    var addToCartStatus: RootClassAddToCartStatus?
    var averageRating: Float = 0.0
    var badges: RootClassBadges?
    var brandSegmentation: Bool = false
    var cancelAcceptedPeriod: Int = 0
    var category: RootClassCategory?
    var categoryId: Int = 0
    var channel: Int = 0
    var cleanedProperties: RootClassCleanedProperties?
    var commentCount: Int = 0
    var consumerFriendlyDescription: String?
    var cost: RootClassCost?
    var createdTime: String?
    var digitalAsset: Bool = false
    var dynamicAttributes: RootClassDynamicAttributes?
    var ecommItemType: String?
    var enablePersonalization: Bool = false
    var everydayValueFlag: Bool = false
    var featured: Bool = false
    var filteredVariants = [RootClassFilteredVariants]()
    var freeTitleInfo: String?
    var fulfillment: RootClassFulfillment?
    var fullMenuPath: String?
    var fullTaxonomyPath: String?
    var globalTradeItemNumberType: Int = 0
    var inventoryInfo: RootClassInventoryInfo?
    var inventoryMcu: RootClassInventoryMcu?
    var isAssorted: Bool = false
    var isFinishedGoods: Bool = false
    var isOnlineOnly: Bool = false
    var isPrimarySku: Bool = false
    var isSubscribeable: Bool = false
    var isThirdPartyProduct: Bool = false
    var itemName: String?
    var itemNumber: String?
    var itemPrice: RootClassItemPrice?
    var itemProperties: RootClassItemProperties?
    var itemStatus: String?
    var itemType: String?
    var longDescription: String?
    var media = [RootClassMedia]()
    var mediumDescription: String?
    var menuExternalId: String?
    var mikAgeVerReqInd: String?
    var mikServerInfoPerformance: RootClassMikServerInfoPerformance?
    var mikStrategyCode: Int = 0
    var newFlagDate: String?
    var onlineInventoryAvailable: Bool = false
    var onlineOnly: RootClassOnlineOnly?
    var others: RootClassOthers?
    var overallRating: Float = 0.0
    var parentTaxonomyPath: String?
    var price: Float = 0.0
    var priceDetail: RootClassPriceDetail?
    var productId: String?
    var project: RootClassProject?
    var promotionMpe: RootClassPromotionMpe?
    var regulation: RootClassRegulation?
    var returnAcceptedPeriod: Int = 0
    var roles: RootClassRoles?
    var search: RootClassSearch?
    var searchProperties: RootClassSearchProperties?
    var seasonalItem: Bool = false
    var shipInfo: RootClassShipInfo?
    var shipping: RootClassShipping?
    var shortDescription: String?
    var similarProducts: RootClassSimilarProducts?
    var skuDisplayName: String?
    var skuGroup: String?
    var skuName: String?
    var skuNumber: String?
    var skuType: Int = 0
    var sortedOriginPrice = [Float]()
    var sortedPrice = [Float]()
    var status: Int = 0
    var storeOnly: Bool = false
    var subSkus = [String]()
    var subSkuWithColor = [RootClassSubSkuWithColor]()
    var tags = [String]()
    var taxonomyExternalId: String?
    var taxonomyExternalIdPath: String?
    var taxonomyExternalIdPaths = [String]()
    var taxonomyExternalIds = [String]()
    var taxonomyId: Int = 0
    var taxonomyIdList = [Int]()
    var taxonomyLongName: String?
    var taxonomyPathList = [String]()
    var thumbnailUrl: String?
    var totalOfRating: Int = 0
    var upcNumber: String?
    var updateDatetime: String?
    var urlMenuPath: String?
    var urlTaxonomyPath: String?
    var variantCountMap: RootClassVariantCountMap?
    var variants: [String: Any]?
    var vendor: RootClassVendor?
}

struct RootClassCleanedProperties: HandyJSON {
    var sizeUom: String?
}

struct RootClassDynamicAttributes: HandyJSON {
    var basic_Attributes__ID: String?
    var basic_Attributes__Translation_Complete: String?
    var category_Long_Name_Path: String?
    var container: String?
    var content__Project_List: String?
    var digital_Assets__HeroID: String?
    var dropship_Attribute__Cost: String?
    var organization: String?
    var retek_Attributes__Online: String?
    var retek_Attributes__Related_UPCs: String?
    var retek_Attributes__Vendor_Part_no: String?
    var site_Merchant__Dropship: String?
    var site_Merchant__EDV: String?
    var site_Merchant__Pro_Alt_SKU: String?
    var site_Merchant__Search_Placement_Group: String?
}

struct RootClassCategory: HandyJSON {
    var categoryNumber: String?
    var className: String?
    var classNumber: String?
    var departmentName: String?
    var departmentNumber: String?
    var divisionName: String?
    var divisionNumber: String?
    var subClassName: String?
    var subClassNumber: String?
}

struct RootClassVariants: HandyJSON {
    var variantContent = [String]()
    var variantId: String?
    var variantName: String?
    var variantSwatchUrls: RootClassVariantsVariantSwatchUrls?
    var variantType: String?
    var variantUOM = [String]()
}

struct RootClassVariantsVariantSwatchUrls: HandyJSON {

}

struct RootClassPromotionMpe: HandyJSON {
    var offer = [RootClassPromotionMpeOffer]()
}

struct RootClassPromotionMpeOffer: HandyJSON {
    var calloutMessage: String?
    var disclaimer: String?
    var type: String?
}

struct RootClassItemProperties: HandyJSON {
    var backorderAble: String?
    var brandBucket: String?
    var brandName: String?
    var colorFamily: String?
    var colorName: String?
    var size: String?
    var totalCountInUnit: String?
}

struct RootClassSubSkuWithColor: HandyJSON {
    var colorName: String?
    var fullSizeUrl: String?
    var shipping: RootClassSubSkuWithColorShipping?
    var skuNumber: String?
    var swatchImageUrl: String?
    var thumbnailUrl: String?
}

struct RootClassSubSkuWithColorShipping: HandyJSON {
    var bopisMinimumOrderQuantity: String?
    var groundShipOnly: String?
    var isHazmat: String?
    var shipAlone: String?
    var shipAsItIs: String?
    var wcmsStatus: String?
}

struct RootClassRegulation: HandyJSON {
    var caPropChemicals: String?
    var componentMaterialBreakdown: String?
    var flammableContent: String?
    var hazardType: String?
    var hazmatIndicator: String?
}

struct RootClassOnlineOnly: HandyJSON {
    var availableFromDate: String?
    var availableToDate: String?
}

struct RootClassSearchProperties: HandyJSON {
    var availableForInStorePickup: String?
}

struct RootClassSearch: HandyJSON {
    var headline: String?
    var metaDescription: String?
    var searchableIfUnavailable: String?
    var seoRanking: String?
}

struct RootClassMikServerInfoPerformance: HandyJSON {
    var productDetailTimeElapsed: Int = 0
    var productInventoryTimeElapsed: Int = 0
    var productPriceTimeElapsed: Int = 0
    var productPromotionTimeElapsed: Int = 0
    var productRatingTimeElapsed: Int = 0
    var totalTimeElapsed: Int = 0
}

struct RootClassMedia: HandyJSON {
    var fullSizeUrl: String?
    var isHero: String?
    var largeUrl: String?
    var mediaId: String?
    var mediaSizeId: String?
    var mediaType: Int = 0
    var mimeTypeId: String?
    var smallImageUrl: String?
    var sort: Int = 0
    var thumbnailUrl: String?
}

struct RootClassInventoryInfo: HandyJSON {
    var storeInventoryVisible: String?
    var storeSkuStatus: String?
}

struct RootClassFulfillment: HandyJSON {
    var isInStorePickup: String?
    var shipOrPickupFromLocationNumber: String?
}

struct RootClassOthers: HandyJSON {
    var categoryPath: String?
    var parentExternalId: String?
    var quickLinkSections: String?
}

struct RootClassAddToCartStatus: HandyJSON {
    var addToCartStatus: Bool = false
    var notAvailableReason: String?
}

struct RootClassProject: HandyJSON {
    var projectName: String?
}

struct RootClassItemPrice: HandyJSON {
    var orgPrice: String?
    var orgPriceRange: String?
    var price: String?
    var priceRange: String?
    var savedAmount: String?
    var savedPercent: String?
    var unitPrice: String?
}

struct RootClassInventoryMcu: HandyJSON {
    var availableQuantity: Int = 0
    var inStock: Bool = false
    var masterSkuNumber: String?
    var michaelsStoreId: String?
    var sellerStoreId: String?
    var skuNumber: String?
    var updatedTime: String?
}

struct RootClassRoles: HandyJSON {
    var vendorId: String?
    var vendorName: String?
}

struct RootClassShipInfo: HandyJSON {
    var volume: Int = 0
}

struct RootClassPriceDetail: HandyJSON {
    var currency: String?
    var endTime: Int = 0
    var masterSkuNumber: String?
    var michaelsStoreId: String?
    var originPrice: Float = 0.0
    var price: Float = 0.0
    var sellerStoreId: String?
    var skuNumber: String?
}

struct RootClassVendor: HandyJSON {
    var vendorNumber: String?
}

struct RootClassSimilarProducts: HandyJSON {

}

struct RootClassVariantCountMap: HandyJSON {

}

struct RootClassFilteredVariants: HandyJSON {
    var variantContent = [String]()
    var variantId: String?
    var variantName: String?
    var variantSwatchUrls: RootClassFilteredVariantsVariantSwatchUrls?
    var variantType: String?
    var variantUOM = [String]()
}

struct RootClassFilteredVariantsVariantSwatchUrls: HandyJSON {

}

struct RootClassCost: HandyJSON {
    var bulkDeal: String?
    var mikTaxCode: String?
    var retailCurrent: String?
    var surcharge: String?
    var taxClass: String?
}

struct RootClassBadges: HandyJSON {
    var freeStorePickup: Bool = false
    var onlineOnly: Bool = false
    var sameDayDelivery: Bool = false
}

struct RootClassShipping: HandyJSON {
    var bopisMinimumOrderQuantity: String?
    var groundShipOnly: String?
    var isHazmat: String?
    var shipAlone: String?
    var shipAsItIs: String?
    var wcmsStatus: String?
}


struct RecommendSkusModel: HandyJSON {
    
    
    
}
