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
    
    let gMap: GoogleMap
    
    init(shopsMapVM: ShopsMapViewModel) {
        gMap = GoogleMap(shopsMapVM)
    }
    
    init(registeringShopVM: RegisteringShopViewModel) {
        gMap = GoogleMap(registeringShopVM)
    }
    
    init(inspectingRequestVM: ReviewingRequestViewModel) {
        gMap = GoogleMap(inspectingRequestVM)
    }
    
    init(from shop: Shop) {
        gMap = GoogleMap(shop)
    }
    
    // MARK: called only once
    func makeUIView(context: Self.Context) -> GMSMapView {
        return gMap.makeMapView()
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Self.Context) {
        gMap.updateMapView(mapView)
    }
}
