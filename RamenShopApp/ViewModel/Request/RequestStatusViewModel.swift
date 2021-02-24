//
//  RequestStatusViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-03.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
class RequestStatusViewModel: ObservableObject {
    @Published var shopName: String?
    @Published var inspectionStatus: ReviewingStatus?
    @Published var isShowAlert = false
    @Published var rejectReason = Constants.EMPTY
    @Published var isShowingProgress = false
    var db: DatabaseHelper
    var authentication: Authentication
    var userID: String
    var requestedShopID: String
    var activeAlert: ActiveAlert = .confirmation
    var hasRequest: Bool {
        return (shopName != nil) && (inspectionStatus != nil)
    }
    var isRejected: Bool {
        guard let _status = inspectionStatus else { return false }
        return _status == .rejected
    }
    var annotation: String {
        guard let _status = inspectionStatus else { return Constants.EMPTY }
        switch _status {
        case .inProcess:
            return Constants.REQUEST_STATUS_MESSAGE_IN_PROCESS
        default:
            return Constants.REQUEST_STATUS_MESSAGE_OTHER
        }
    }
    
    var delegate: RequestStatusVMDelegate?
    
    init(_ userID: String,
         _ requestedShopID: String,
         delegate: RequestStatusVMDelegate?) {
        db = .init()
        authentication = .init()
        self.userID = userID
        self.requestedShopID = requestedShopID
        db.delegate = self
        self.delegate = delegate
        fetchRequestStatus()
    }
    
    func fetchRequestStatus() {
        isShowingProgress = true
        db.fetchShop(shopID: self.requestedShopID)
    }
    
    func cancelRequest() {
        isShowingProgress = true
        db.deleteShopRequest(shopID: requestedShopID)
    }
    
    func removeRequestInfoFromProfile() {
        isShowingProgress = true
        db.deleteRequestUserInfo(userID: userID)
    }
    
    func resetData() {
        activeAlert = .confirmation
        shopName = nil
        inspectionStatus = nil
        
        delegate?.reloadRequest()
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
    
    func completedFetchingShop(fetchedShopData: Shop) {
        isShowingProgress = false
        shopName = fetchedShopData.name
        inspectionStatus = fetchedShopData.reviewingStatus
        
        if inspectionStatus == .rejected {
            db.fetchRejectReason(shopID: fetchedShopData.shopID)
        }
    }
    
    //MARK: TODO even if failed, should do removeRequestInfoFromProfile(),,,? to avoid that request data remains only in user
    func completedDeletingingShopRequest(isSuccess: Bool) {
        if isSuccess {
            removeRequestInfoFromProfile()
        } else {
            isShowingProgress = false
            activeAlert = .error
            isShowAlert = true
        }
    }
    
    func completedDeletingRequestUserInfo(isSuccess: Bool) {
        isShowingProgress = false
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

protocol RequestStatusVMDelegate {
    func reloadRequest()
}
