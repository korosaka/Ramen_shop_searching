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
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    }
                    .navigationBarHidden(true)
                
                RegisteringShopNameView(viewModel: .init())
                    .tabItem {
                        VStack {
                            Image(systemName: "plus")
                            Text("Add")
                        }.frame(width: 10)
                    }
                    .navigationBarHidden(true)
            }
        }
    }
}
