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
    var requestedShopID: String?
    var activeAlert: ActiveAlert = .confirmation
    @Published var shopName: String?
    @Published var inspectionStatus: InspectionStatus?
    @Published var isShowAlert = false
    @Published var rejectReason = ""
    var hasRequest: Bool {
        return (shopName != nil) && (inspectionStatus != nil)
    }
    var isRejected: Bool {
        guard let _status = inspectionStatus else { return false }
        return _status == .rejected
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
    
    func cancelRequest() {
        guard let _shopID = requestedShopID else { return }
        db.deleteShopRequest(shopID: _shopID)
    }
    
    func removeRequestInfoFromProfile() {
        db.deleteRequestUserInfo(userID: userID)
    }
    
    func resetData() {
        activeAlert = .confirmation
        requestedShopID = nil
        shopName = nil
        inspectionStatus = nil
        checkRequestedShopID()
    }
    
    func onClickConfirmation() {
        guard let _status = inspectionStatus else { return }
        switch _status {
        case .approved:
            removeRequestInfoFromProfile()
        default:
            cancelRequest()
        }
    }
}

extension RequestStatusViewModel: FirebaseHelperDelegate {
    func completedFetchingRequestedShopID(shopID: String?) {
        guard let _shopID = shopID else { return }
        db.fetchShop(shopID: _shopID)
        requestedShopID = _shopID
    }
    
    func completedFetchingShop(fetchedShopData: Shop) {
        shopName = fetchedShopData.name
        inspectionStatus = fetchedShopData.inspectionStatus
        
        if inspectionStatus == .rejected {
            db.fetchRejectReason(shopID: fetchedShopData.shopID)
        }
    }
    
    func completedDeletingingShopRequest(isSuccess: Bool) {
        if isSuccess {
            removeRequestInfoFromProfile()
        } else {
            activeAlert = .error
            isShowAlert = true
        }
    }
    
    func completedDeletingRequestUserInfo(isSuccess: Bool) {
        if isSuccess {
            activeAlert = .completion
        } else {
            activeAlert = .error
        }
        isShowAlert = true
    }
    
    func completedFetchingRejectReason(reason: String) {
        rejectReason = reason
    }
}
