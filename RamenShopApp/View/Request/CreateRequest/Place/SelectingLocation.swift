//
//  SelectingLocation.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-26.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct SelectingLocation: View {
    @ObservedObject var viewModel: RegisteringShopViewModel
    var body: some View {
        ZStack {
            GoogleMapView(registeringShopVM: viewModel)
            CenterMarker()
        }
        .cornerRadius(20)
    }
}
