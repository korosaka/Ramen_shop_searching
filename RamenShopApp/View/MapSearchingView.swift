//
//  MapSearchingView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-09.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct MapSearchingView: View {
    var viewModel: MapSearchingViewModel
    var body: some View {
        Text("Map Searching View")
        GoogleMapView()
    }
}

//struct MapSearchingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapSearchingView()
//    }
//}
