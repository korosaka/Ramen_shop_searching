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
            ZStack(alignment: .topTrailing) {
                GoogleMapView(shops: viewModel.shops)
                    .onAppear { self.viewModel.loadShops() }
                    .padding(5)
                    .background(Color.blue)
                
                Button(action: {
                    self.viewModel.loadShops()
                }) {
                    Text("Reload")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.purple)
                        .cornerRadius(13)
                        .overlay(RoundedRectangle(cornerRadius: 13)
                                    .stroke(Color.black, lineWidth: 2)
                        )
                        .padding(10)
                }
            }
            .tabItem { Text("Searching") }
            
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
