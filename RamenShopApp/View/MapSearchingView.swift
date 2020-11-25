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
        TabView {
            VStack {
                Button(action: {
                    self.viewModel.loadShops()
                }) {
                    Text("Reload")
                }
                GoogleMapView(shops: viewModel.shops).onAppear {
                    self.viewModel.loadShops()
                }
            }.tabItem { Text("Searching") }
            Text("Adding mode")
                .tabItem { Text("Add") }
        }
    }
}

//struct MapSearchingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapSearchingView()
//    }
//}
