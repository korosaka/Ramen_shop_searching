//
//  InspectingRequestViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-13.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
class InspectingRequestViewModel: ObservableObject {
    let requestedShop: Shop
    @Published var currentShops: [Shop]
    var db: FirebaseHelper
    
    init(request: Shop) {
        db = .init()
        requestedShop = request
        currentShops = .init()
        db.delegate = self
        db.fetchShops(target: .approved)
    }
    
    func getTargetLatitude() -> Double {
        return requestedShop.location.latitude
    }
    
    func getTargetLongitude() -> Double {
        return requestedShop.location.longitude
    }
}

extension InspectingRequestViewModel: FirebaseHelperDelegate {
    func completedFetchingShops(shops: [Shop]) {
        currentShops = shops
    }
}
