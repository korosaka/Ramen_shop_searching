//
//  RequestingTopViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-07.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
class RequestingTopViewModel: ObservableObject {
    var db: DatabaseHelper
    var authentication: Authentication
    var userID: String?
    @Published var requestedShopID: String?
    var hasRequest: Bool {
        return requestedShopID != nil
    }
    
    init() {
        db = .init()
        authentication = .init()
        checkCurrentUser()
        db.delegate = self
        checkRequestedShopID()
    }
    
    func checkCurrentUser() {
        guard let _userID = authentication.getUserUID() else { return }
        userID = _userID
    }
    
    func checkRequestedShopID() {
        guard let _userID = userID else { return }
        db.fetchRequestedShopID(userID: _userID)
    }
    
    func reload() {
        checkRequestedShopID()
    }
}

extension RequestingTopViewModel: FirebaseHelperDelegate {
    func completedFetchingRequestedShopID(shopID: String?) {
        guard let _shopID = shopID else {
            requestedShopID = nil
            return
        }
        db.fetchShop(shopID: _shopID)
        requestedShopID = _shopID
    }
}

extension RequestingTopViewModel: RegisteringShopVMDelegate {
    func reloadRequestStatus() {
        reload()
    }
}

extension RequestingTopViewModel: RequestStatusVMDelegate {
    func reloadRequest() {
        reload()
    }
}
