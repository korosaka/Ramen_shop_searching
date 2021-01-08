//
//  RegisteringShopViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-02.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
class RegisteringShopViewModel: ObservableObject {
    var db: FirebaseHelper
    var authentication: Authentication
    @Published var shopName = ""
    @Published var isShowAlert = false
    var userID: String?
    var activeAlertForName = ActiveAlert.confirmation
    var isNameSet: Bool {
        return shopName != ""
    }
    var location: GeoPoint?
    var zoom: Float?
    var isZoomedEnough: Bool {
        guard let _zoom = zoom else { return false }
        return _zoom > 19.0
    }
    
    init() {
        db = .init()
        authentication = .init()
        db.delegate = self
        checkCurrentUser()
    }
    
    func checkCurrentUser() {
        guard let _userID = authentication.getUserUID() else { return }
        userID = _userID
    }
    
    func resetData() {
        shopName = ""
        activeAlertForName = .confirmation
        location = nil
        zoom = nil
    }
    
    func setLocation(latitude: Double, longitude: Double) {
        location = GeoPoint(latitude: latitude, longitude: longitude)
    }
    
    func setZoom(zoom: Float) {
        self.zoom = zoom
    }
    
    func sendShopRequest() {
        guard let _userID = userID,
              let _location = location else {
            activeAlertForName = .error
            isShowAlert = true
            return
        }
        db.uploadShopRequest(shopName: shopName,
                             location: _location,
                             userID: _userID)
    }
    
    func getTextColor(enable: Bool) -> Color {
        if enable {
            return .white
        }
        return .gray
    }
}

extension RegisteringShopViewModel: FirebaseHelperDelegate {
    func completedUplodingShopRequest(isSuccess: Bool) {
        if isSuccess {
            activeAlertForName = .completion
        } else {
            activeAlertForName = .error
        }
        isShowAlert = true
    }
}
