//
//  LocationStore.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-05.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
import GoogleMaps

class LocationStore {
    let userIDKey = "user_id"
    let latitudeKey = "latitude_value"
    let longitudeKey = "longitude_value"
    
    func storeLocation(location: CLLocationCoordinate2D) {
        UserDefaults.standard.set(location.latitude, forKey: latitudeKey)
        UserDefaults.standard.set(location.longitude, forKey: longitudeKey)
    }
    
    func storeUserID(_ userID: String) {
        UserDefaults.standard.set(userID, forKey: userIDKey)
    }
    
    func testPrint() {
        //MARK: if any data can't be got, return 0.0
        print("test1", UserDefaults.standard.double(forKey: latitudeKey))
    }
}
