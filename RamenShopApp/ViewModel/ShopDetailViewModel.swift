//
//  ShopDetailViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-02.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import SwiftUI
class ShopDetailViewModel: ObservableObject {
    
    var db: FirebaseHelper
    @Published var latestReviews: [Review]
    @Published var pictures: [UIImage]
    @Published var shop: Shop?
    var isLoading = (review: false, picture: false)
    @Published var isShowingProgress = false
    
    init(mapVM: ShopsMapViewModel) {
        if mapVM.isShopSelected {
            shop = mapVM.selectedShop!
        }
        self.db = .init()
        latestReviews = .init()
        pictures = .init()
        db.delegate = self
        fetchDataFromDB()
    }
    
    func fetchDataFromDB() {
        if shop == nil { return }
        isLoading = (true, true)
        isShowingProgress = true
        db.fetchLatestReviews(shopID: shop!.shopID)
        let maxReviewCount = 3
        db.fetchPictureReviews(shopID: shop!.shopID, limit: maxReviewCount)
    }
    
    func reloadShop() {
        guard let shopID = shop?.shopID else { return }
        db.fetchShop(shopID: shopID)
    }
}

extension ShopDetailViewModel: FirebaseHelperDelegate {
    func completedFetchingReviews(reviews: [Review]) {
        isLoading.review = false
        if !isLoading.picture { isShowingProgress = false }
        latestReviews = reviews
    }
    func completedFetchingPictures(pictures: [UIImage]) {
        isLoading.picture = false
        if !isLoading.review { isShowingProgress = false }
        self.pictures = pictures
    }
    
    func completedFetchingShop(fetchedShopData: Shop) {
        shop = fetchedShopData
    }
}

extension ShopDetailViewModel: ReviewingVMDelegate {
    func stopReviewing() {
        fetchDataFromDB()
        reloadShop()
    }
}
