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
            GoogleMapView(registeringShopVM: viewModel)
                .padding(5)
                .background(Color.blue)
            Spacer()
        }
        .navigationBarHidden(true)
    }
    
}
