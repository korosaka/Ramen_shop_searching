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
    var inspectingRequestVM: ReviewingRequestViewModel?
    var particularShop: Shop?
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
    
    init(_ inspectingRequestVM: ReviewingRequestViewModel) {
        self.inspectingRequestVM = inspectingRequestVM
        mapType = .admin
        super.init()
    }
    
    init(_ shop: Shop) {
        particularShop = shop
        mapType = .fromShop
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
        //MARK: for when location is not permitted
        let camera = GMSCameraPosition.camera(withLatitude: 50.0, longitude: -100.0, zoom: 1.0)
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
            showTargetShop(inspectingRequestVM?.requestedShop, mapView)
            showAllShops(mapView, shops: inspectingRequestVM?.currentShops, filterIndex: nil, filterValues: [])
            return
        case .searching:
            showAllShops(mapView,
                         shops: shopsMapVM?.shops,
                         filterIndex: shopsMapVM?.evaluationFilter, filterValues: shopsMapVM!.filterValues)
        case .registering:
            return
        case .fromShop:
            showTargetShop(particularShop, mapView)
            return
        }
        
        guard let locationInfo = mapView.myLocation?.coordinate else { return }
        centerUserLocation(mapView, locationInfo)
        guard let userID = Authentication().getUserUID() else { return }
        DatabaseHelper().updateUserLocation(userID: userID, location: locationInfo)
    }
    
    func centerUserLocation(_ mapView: GMSMapView, _ location: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                              longitude: location.longitude, zoom: 11.0)
        mapView.camera = camera
    }
    
    func showTargetShop(_ targetShop: Shop?, _ mapView: GMSMapView) {
        guard let shop = targetShop else { return }
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: shop.location.latitude, longitude: shop.location.longitude)
        marker.map = mapView
    }
    
    func showAllShops(_ mapView: GMSMapView, shops: [Shop]?, filterIndex: Int?, filterValues: [Float]) {
        guard let _shops = shops else { return }
        
        for shop in _shops {
            if isOutOfFilter(filterIndex,
                             filterValues,
                             shopEva: shop.aveEvaluation) {
                continue
            }
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
    
    func isOutOfFilter(_ filterIndex: Int?, _ filterValues: [Float], shopEva: Float) -> Bool {
        if !isValidFilter(filterIndex) { return false }
        return shopEva < filterValues[filterIndex!]
    }
    
    func isValidFilter(_ filterIndex: Int?) -> Bool {
        guard let _filterIndex = filterIndex else { return false }
        return _filterIndex >= 0
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
    case searching, registering, admin, fromShop
}
