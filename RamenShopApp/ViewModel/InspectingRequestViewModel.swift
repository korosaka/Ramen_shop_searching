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
}

protocol InspectingRequestVMDelegate {
    func completedInspectionRequest()
}

extension InspectingRequestViewModel: FirebaseHelperDelegate {
    func completedFetchingShops(shops: [Shop]) {
        currentShops = shops
    }
    
    func completedUpdatingRequestStatus(isSuccess: Bool) {
//        let testFcmToken = "fjnVCahel0QElSLHaSlWdO:APA91bH6-Yp0BYLUtcFs7u5vSxaxxCKaJA33W5ePtVYpDuyN57xhRtCqY3OSzfImGUeO2VTCfeSXPpEmi-J6RLniQFMgtIv6mOhUP5Pu3bzcatpbobyIK1OBVgEGx9FFuDqie7oKDbSG"
        if isSuccess {
            activeAlert = .completion
//            PushNotificationSender().sendPushNotification(to: testFcmToken, title: "test push", body: "this is test push notification!!")
        } else {
            activeAlert = .error
        }
        isShowingAlert = true
    }
}
