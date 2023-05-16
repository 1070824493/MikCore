//
//  MichaelsProductModel.swift
//  MikCore_Example
//
//  Created by zhenrong on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import HandyJSON

struct MichaelsProductModel: HandyJSON {
    var aggregationResults: MichaelsProductAggregationResults?
    var classifiedResult: String?
    var clearSearchIntention: Bool = false
    var code: Int = 0
    var correctedSpelling: String?
    var correctedSpellingProcessedQuery: String?
    var message: String?
    var ratingCountScore: String?
    var relevanceScore: String?
    var searchResults: MichaelsProductSearchResults?
}

struct MichaelsProductAggregationResults: HandyJSON {
    var aggregationByFacetKeyResultList = [MichaelsProductAggregationResultsAggregationByFacetKeyResultList]()
    var totalAggregations: Int = 0
}

struct MichaelsProductAggregationResultsAggregationByFacetKeyResultList: HandyJSON {
    var aggregatedFacetValues = [MichaelsProductAggregationResultsAggregationByFacetKeyResultListAggregatedFacetValues]()
    var facetKey: String?
}

struct MichaelsProductAggregationResultsAggregationByFacetKeyResultListAggregatedFacetValues: HandyJSON {
    var facetValue: String?
    var facetValueCounts: Int = 0
}

struct MichaelsProductSearchResults: HandyJSON {
    var itemIds = [String]()
    var items = [MichaelsProductSearchResultsItems]()
    var scores = [Float]()
    var totalResultCount: Int = 0
}

struct MichaelsProductSearchResultsItems: HandyJSON {
    var categoryName = [String]()
    var channel: String?
    var description: String?
    var discountPrice: String?
    var facets: String?
    var getItFast: String?
    var id: String?
    var inStorePickup: String?
    var inventory: String?
    var largeImageUrl: String?
    var masterSku: String?
    var michaelsStoreInventory: String?
    var newFlagDate: String?
    var numberOfRatings: Float = 0.0
    var price: Float = 0.0
    var price_score: Float = 0.0
    var productName: String?
    var purchase_score: Float = 0.0
    var rating: Float = 0.0
    var revenue_score: Float = 0.0
    var sameDayDelivery: String?
    var shipToMe: String?
    var shortDescription: String?
    var skuNumber: String?
    var smallImageUrl: String?
    var status: String?
    var store: String?
    var storeId: String?
    var storeStatus: String?
    var updatedTime: String?
}
