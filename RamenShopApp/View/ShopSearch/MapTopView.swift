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
                            Text(Constants.SEARCH)
                        }
                    }
                    .navigationBarHidden(true)
                
                RequestingTopView(viewModel: .init())
                    .tabItem {
                        VStack {
                            Image(systemName: "plus")
                            Text(Constants.ADD)
                        }
                    }
                    .navigationBarHidden(true)
                ProfileView()
                    .environmentObject(ProfileViewModel())
                    .tabItem {
                        VStack {
                            Image(systemName: "person.fill")
                            Text(Constants.PROFILE)
                        }
                    }
                    .navigationBarHidden(true)
                SettingsView()
                    .tabItem {
                        VStack {
                            Image(systemName: "list.bullet")
                            Text(Constants.SETTINGS)
                        }
                    }
                    .navigationBarHidden(true)
            }
        }
    }
}
