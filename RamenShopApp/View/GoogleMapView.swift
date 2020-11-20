//
//  GoogleMapView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-18.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI
import UIKit
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    
    let marker : GMSMarker = GMSMarker()
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 49.284832194, longitude: -123.106999572, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Self.Context) {
        // Creates a marker in the center of the map.
        marker.position = CLLocationCoordinate2D(latitude: 49.284832194, longitude: -123.106999572)
        marker.title = "Waterfront"
        marker.snippet = "Vancouver"
        marker.map = mapView
    }
}

//struct GoogleMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoogleMapView()
//    }
//}
