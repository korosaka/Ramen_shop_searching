//
//  RequestStatusView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-03.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RequestStatusView: View {
    @ObservedObject var viewModel: RequestStatusViewModel
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(additionalAction: nil)
            Text("RequestStatusView")
            Spacer()
        }
        .background(Color.green)
        .navigationBarHidden(true)
    }
}

