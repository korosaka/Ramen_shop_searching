//
//  GoogleMapView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-18.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI
import GoogleMaps

// MARK: to use UIKit's View(GMSMapView) in SwiftUI
struct GoogleMapView: UIViewRepresentable {
    
    var shops: [Shop]
    
    init(shops: [Shop]) {
        self.shops = shops
    }
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        return GoogleMap().makeMapView()
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Self.Context) {
        GoogleMap().updateMapView(mapView, shops)
    }
}
