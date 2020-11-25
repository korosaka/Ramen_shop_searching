//
//  MapSearchingView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-09.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct MapSearchingView: View {
    @ObservedObject var viewModel: MapSearchingViewModel
    var body: some View {
        Button(action: {
            self.viewModel.loadShops()
        }) {
            Text("Reload")
        }
        Text("Map Searching View")
        GoogleMapView(shops: viewModel.shops).onAppear {
            self.viewModel.loadShops()
        }
    }
}

//struct MapSearchingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapSearchingView()
//    }
//}
