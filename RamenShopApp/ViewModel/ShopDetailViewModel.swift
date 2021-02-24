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
    
    @Published var latestReviews: [Review]
    @Published var pictures: [UIImage]
    @Published var favorite = false
    @Published var shop: Shop?
    @Published var isShowingProgress = false
    var db: DatabaseHelper
    var isLoading = (review: false, picture: false, favorite: false)
    var isFromProfile = false
    
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
    
    //MARK: when navigated from Profile
    init(shopID: String) {
        self.db = .init()
        latestReviews = .init()
        pictures = .init()
        db.delegate = self
        isFromProfile = true
        db.fetchShop(shopID: shopID)
    }
    
    func fetchDataFromDB() {
        guard let shopID = shop?.shopID,
              let userID = Authentication().getUserUID()
        else { return }
        isLoading = (true, true, true)
        isShowingProgress = true
        db.fetchLatestReviews(shopID: shopID)
        let maxReviewCount = 3
        db.fetchPictureReviews(shopID: shopID, limit: maxReviewCount)
        db.fetchFavoriteFlag(userID, shopID)
    }
    
    func reloadShop() {
        guard let shopID = shop?.shopID else { return }
        db.fetchShop(shopID: shopID)
    }
    
    func checkLoadingStatuses() {
        if !isLoading.picture && !isLoading.review && !isLoading.favorite {
            isShowingProgress = false
        }
    }
    
    func switchFavorite() {
        guard let shopID = shop?.shopID,
              let userID = Authentication().getUserUID()
        else { return }
        favorite.toggle()
        db.updateFavoriteFlag(userID, shopID, favoFlag: favorite)
    }
}

extension ShopDetailViewModel: FirebaseHelperDelegate {
    func completedFetchingReviews(reviews: [Review]) {
        isLoading.review = false
        checkLoadingStatuses()
        latestReviews = reviews
    }
    func completedFetchingPictures(pictures: [UIImage], shopID: String?) {
        isLoading.picture = false
        checkLoadingStatuses()
        self.pictures = pictures
    }
    
    func completedFetchingShop(fetchedShopData: Shop) {
        shop = fetchedShopData
        if isFromProfile { fetchDataFromDB() }
    }
    
    func completedFetchingFavoFlag(flag: Bool) {
        isLoading.favorite = false
        checkLoadingStatuses()
        favorite = flag
    }
}

extension ShopDetailViewModel: ReviewingVMDelegate {
    func stopReviewing() {
        fetchDataFromDB()
        reloadShop()
    }
}
