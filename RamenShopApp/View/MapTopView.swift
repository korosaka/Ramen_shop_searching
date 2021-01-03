//
//  MapSearchingView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-09.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct MapTopView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(additionalAction: nil)
            TabView {
                ShopsMapView(viewModel: .init())
                    .tabItem { Text("Searching") }
                    .navigationBarHidden(true)
                
                RegisteringShopNameView(viewModel: .init())
                    .tabItem { Text("Add") }
                    .navigationBarHidden(true)
            }
        }
    }
}
