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
    var requestedShopID: String
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
    var annotation: String {
        guard let _status = inspectionStatus else { return "" }
        switch _status {
        case .inProcess:
            return "※You cannot create another request until reviewing this request would finish or canceling it."
        default:
            return "※If you wanna create new request, you need to click the above button."
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
        db.fetchShop(shopID: self.requestedShopID)
    }
    
    func cancelRequest() {
        db.deleteShopRequest(shopID: requestedShopID)
    }
    
    func removeRequestInfoFromProfile() {
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

protocol RequestStatusVMDelegate {
    func reloadRequest()
}
