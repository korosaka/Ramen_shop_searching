//
//  MapSearchingViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-23.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
class MapSearchingViewModel: ObservableObject {
    var shopDB: FirebaseHelper
    @Published var shops: [Shop]
    @Published var isShopSelected = false
    var selectedShop: Shop?
    
    init() {
        shopDB = .init()
        shops = [Shop]()
        shopDB.delegate = self
    }
    
    func loadShops() {
        shopDB.fetchShops()
    }
    
    func selectShop(id: String, name: String) {
        for shop in shops {
            if shop.shopID == id {
                selectedShop = shop
                // MARK: this Bool will be false when back to MapSearchingView by NavigationLink
                isShopSelected = true
                break
            }
        }
    }
}

extension MapSearchingViewModel: FirebaseHelperDelegate {
    func completedFetchingShops(shops: [Shop]) {
        self.shops = shops
    }
}
