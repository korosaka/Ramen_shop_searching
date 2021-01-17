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
    var inspectingRequestVM: InspectingRequestViewModel?
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
    
    init(_ inspectingRequestVM: InspectingRequestViewModel) {
        self.inspectingRequestVM = inspectingRequestVM
        mapType = .admin
        super.init()
    }
    
    func makeMapView() -> GMSMapView {
        if mapType == .admin {
            let latitude = inspectingRequestVM!.getTargetLatitude()
            let longitude = inspectingRequestVM!.getTargetLongitude()
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 17.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            return mapView
        }
        //MARK: TODO camera should be set current user location
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
        switch mapType {
        case .admin:
            showRequestedShop(inspectingRequestVM?.requestedShop, mapView)
            showAllShops(mapView, shops: inspectingRequestVM?.currentShops)
        case .searching:
            showAllShops(mapView, shops: shopsMapVM?.shops)
        case .registering:
            return
        }
    }
    
    func showRequestedShop(_ requestedShop: Shop?, _ mapView: GMSMapView) {
        guard let shop = requestedShop else { return }
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: shop.location.latitude, longitude: shop.location.longitude)
        marker.map = mapView
    }
    
    func showAllShops(_ mapView: GMSMapView, shops: [Shop]?) {
        guard let _shops = shops else { return }
        
        for shop in _shops {
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
        if mapType != .searching { return }
        shopsMapVM?.selectShop(id: marker.userData as! String, name: marker.title!)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if mapType != .registering { return }
        let location = position.target
        registeringShopVM?.setLocation(latitude: location.latitude,
                                       longitude: location.longitude)
        registeringShopVM?.setZoom(zoom: position.zoom)
    }
}

enum MapType {
    case searching, registering, admin
}
