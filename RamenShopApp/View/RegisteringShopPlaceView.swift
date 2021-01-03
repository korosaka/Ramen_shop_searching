//
//  RegisteringShopPlaceView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-02.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RegisteringShopPlaceView: View {
    @ObservedObject var viewModel: RegisteringShopViewModel
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(additionalAction: nil)
            Text("RegisteringShopPlaceView")
            ZStack {
                GoogleMapView(registeringShopVM: viewModel)
                CenterMarker()
            }
            .padding(5)
            .background(Color.blue)
        }
        .navigationBarHidden(true)
    }
    
}

struct CenterMarker: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                Spacer()
                Image("shop_icon")
                    .resizable()
                    .frame(width: 30.0, height: 30.0)
                Spacer()
            }
            Spacer()
        }
    }
}
