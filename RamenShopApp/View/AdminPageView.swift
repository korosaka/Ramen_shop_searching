//
//  AdminPageView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-12.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct AdminPageView: View {
    
    @ObservedObject var viewModel: AdminPageViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(additionalAction: nil)
            Spacer()
            HStack {
                Spacer()
                Text("AdminPageView")
                Spacer()
            }
            Spacer()
        }
        .background(Color.red)
        .navigationBarHidden(true)
    }
}
