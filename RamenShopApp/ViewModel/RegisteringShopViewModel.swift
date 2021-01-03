//
//  RegisteringShopViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-02.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
import FirebaseFirestore
class RegisteringShopViewModel: ObservableObject {
    @Published var shopName = ""
    @Published var isShowAlert = false
    var activeAlertForName: ActiveAlert = .confirmation
    var isNameSet: Bool {
        return shopName != ""
    }
    var location: GeoPoint?
    var zoom: Float?
    var isZoomedEnough: Bool {
        guard let _zoom = zoom else { return false }
        return _zoom > 19.0
    }
    
    func setLocation(latitude: Double, longitude: Double) {
        location = GeoPoint(latitude: latitude, longitude: longitude)
    }
    
    func setZoom(zoom: Float) {
        self.zoom = zoom
    }
}
