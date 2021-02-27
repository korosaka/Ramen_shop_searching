//
//  InspectingRequestViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-13.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
class ReviewingRequestViewModel: ObservableObject {
    @Published var currentShops: [Shop]
    @Published var rejectReason = Constants.EMPTY
    @Published var isShowingAlert = false
    let requestedShop: Shop
    var activeAlert: ActiveAlert = .confirmation
    var db: DatabaseHelper
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
        return requestedShop.getLocation().latitude
    }
    
    func getTargetLongitude() -> Double {
        return requestedShop.getLocation().longitude
    }
    
    func approve() {
        db.approveRequest(requestedShop.getShopID())
    }
    
    func reject() {
        db.rejectRequest(requestedShop.getShopID(), reason: rejectReason)
    }
    
    func completedInspection() {
        delegate?.completedInspectionRequest()
    }
    
    func informRequester() {
        let userID = requestedShop.getUploadUser()
        db.fetchUserToken(of: userID)
    }
    
    func informNearUsers() {
        db.fetchNearUsers(shopLocation: requestedShop.getLocation(),
                          requesterID: requestedShop.getUploadUser())
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
    
    func completedUpdatingRequestStatus(isSuccess: Bool,
                                        status: ReviewingStatus) {
        if isSuccess {
            activeAlert = .completion
            informRequester()
            if status == .approved { informNearUsers() }
        } else {
            activeAlert = .error
        }
        isShowingAlert = true
    }
    
    func completedFetchingToken(token: String) {
        sendPush(to: token, receiver: .requester)
    }
    
    func completedFetchingNearUsers(tokens: [String]) {
        for token in tokens {
            sendPush(to: token, receiver: .allUser)
        }
    }
}
