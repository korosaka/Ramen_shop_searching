//
//  GoogleMap.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-25.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import GoogleMaps

// MARK: GMSMapViewDelegate cannot be implemented by struct, so This class was created
class GoogleMap: NSObject, GMSMapViewDelegate {
    
    var shopsMapVM: ShopsMapViewModel?
    var registeringShopVM: RegisteringShopViewModel?
    var mapType: MapType
    
    init(_ shopsMapVM: ShopsMapViewModel) {
        self.shopsMapVM = shopsMapVM
        mapType = .searching
        super.init()
    }
    
    init(_ registeringShopVM: RegisteringShopViewModel) {
        self.registeringShopVM = registeringShopVM
        mapType = .registering
        super.init()
    }
    
    func makeMapView() -> GMSMapView {
        // TODO camera should be set current user location
        let camera = GMSCameraPosition.camera(withLatitude: 49.284832194, longitude: -123.106999572, zoom: 11.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        // MARK: is it enough ?? https://developers.google.com/maps/documentation/ios-sdk/current-place-tutorial
        mapView.isMyLocationEnabled = true
        return mapView
    }
    
    // MARK: I don't know why, but "mapView.delegate = self" is invalid in makeMapView(),,,,so did it here
    func updateMapView(_ mapView: GMSMapView) {
        mapView.delegate = self
        mapView.clear()
        guard let shops = shopsMapVM?.shops else { return }
        for shop in shops {
            let marker = GMSMarker()
            let location = shop.location
            marker.icon = UIImage(named: "shop_icon")!.resized(withPercentage: 0.1)
            marker.position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            marker.title = shop.name
            marker.userData = shop.shopID
            marker.snippet = "★" + shop.roundEvaluatione()
            
            marker.map = mapView
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        shopsMapVM?.selectShop(id: marker.userData as! String, name: marker.title!)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if mapType == .searching { return }
        let location = position.target
        registeringShopVM?.setLocation(latitude: location.latitude,
                                       longitude: location.longitude)
        registeringShopVM?.setZoom(zoom: position.zoom)
    }
}

enum MapType {
    case searching, registering
}
