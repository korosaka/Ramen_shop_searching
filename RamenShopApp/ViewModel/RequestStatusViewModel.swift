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
    var userID: String?
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
    
    func cancelRequest() {
        guard let _shopID = requestedShopID else { return }
        db.deleteShopRequest(shopID: _shopID)
    }
    
    func removeRequestInfoFromProfile() {
        guard let _userID = userID else { return }
        db.deleteRequestUserInfo(userID: _userID)
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
