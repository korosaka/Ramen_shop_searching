//
//  InspectingRequestViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-13.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
class ReviewingRequestViewModel: ObservableObject {
    let requestedShop: Shop
    @Published var currentShops: [Shop]
    @Published var rejectReason = ""
    @Published var isShowingAlert = false
    var activeAlert: ActiveAlert = .confirmation
    var db: FirebaseHelper
    var delegate: InspectingRequestVMDelegate?
    
    init(request: Shop, delegate: InspectingRequestVMDelegate?) {
        db = .init()
        requestedShop = request
        currentShops = .init()
        db.delegate = self
        db.fetchShops(target: .approved)
        self.delegate = delegate
    }
    
    func getTargetLatitude() -> Double {
        return requestedShop.location.latitude
    }
    
    func getTargetLongitude() -> Double {
        return requestedShop.location.longitude
    }
    
    func approve() {
        db.approveRequest(requestedShop.shopID)
    }
    
    func reject() {
        db.rejectRequest(requestedShop.shopID, reason: rejectReason)
    }
    
    func completedInspection() {
        delegate?.completedInspectionRequest()
    }
    
    func fetchUserToken() {
        let userID = requestedShop.uploadUser
        db.fetchUserToken(of: userID)
    }
    
    func sendPush(to token: String, receiver: NotificationReceiver) {
        PushNotificationSender()
            .sendPushNotification(to: token,
                                  receiver: receiver)
    }
}

protocol InspectingRequestVMDelegate {
    func completedInspectionRequest()
}

extension ReviewingRequestViewModel: FirebaseHelperDelegate {
    func completedFetchingShops(shops: [Shop]) {
        currentShops = shops
    }
    
    func completedUpdatingRequestStatus(isSuccess: Bool) {
        if isSuccess {
            activeAlert = .completion
            fetchUserToken()
        } else {
            activeAlert = .error
        }
        isShowingAlert = true
    }
    
    func completedFetchingToken(token: String) {
        sendPush(to: token, receiver: .requester)
    }
}
