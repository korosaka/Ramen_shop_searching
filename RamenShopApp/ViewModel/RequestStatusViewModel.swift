//
//  RequestStatusViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-03.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
class RequestStatusViewModel: ObservableObject {
    var db: FirebaseHelper
    var authentication: Authentication
    var userID: String
    @Published var shopName: String?
    @Published var inspectionStatus: InspectionStatus?
    var hasRequest: Bool {
        return (shopName != nil) && (inspectionStatus != nil)
    }
    
    init(userID: String) {
        db = .init()
        authentication = .init()
        self.userID = userID
        db.delegate = self
        checkRequestedShopID()
    }
    
    func checkRequestedShopID() {
        db.fetchRequestedShopID(userID: userID)
    }
}

extension RequestStatusViewModel: FirebaseHelperDelegate {
    func completedFetchingRequestedShopID(shopID: String?) {
        guard let _shopID = shopID else { return }
        db.fetchShop(shopID: _shopID)
    }
    
    func completedFetchingShop(fetchedShopData: Shop) {
        shopName = fetchedShopData.name
        inspectionStatus = fetchedShopData.inspectionStatus
    }
}
