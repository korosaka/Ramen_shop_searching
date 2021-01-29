//
//  AdminPageViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-12.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
class AdminPageViewModel: ObservableObject {
    @Published var requestedShops: [Shop]
    var db: FirebaseHelper
    @Published var isShowingProgress = false
    
    init() {
        requestedShops = .init()
        db = .init()
        db.delegate = self
        fetchRequests()
    }
    
    func fetchRequests() {
        isShowingProgress = true
        db.fetchShops(target: .inProcess)
    }
}

extension AdminPageViewModel: InspectingRequestVMDelegate {
    func completedInspectionRequest() {
        db.fetchShops(target: .inProcess)
    }
}

extension AdminPageViewModel: FirebaseHelperDelegate {
    func completedFetchingShops(shops: [Shop]) {
        isShowingProgress = false
        requestedShops = shops
    }
}
