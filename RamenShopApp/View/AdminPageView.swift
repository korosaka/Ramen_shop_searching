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
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                Spacer().frame(height: 15)
                Text("Shop Requests").middleTitleStyle()
                Spacer().frame(height: 15)
                List {
                    ForEach(viewModel.requestedShops, id: \.shopID) { request in
                        NavigationLink(destination: InspectingRequestView(viewModel: .init(request: request,
                                                                                           delegate: viewModel))) {
                            Text(request.name)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(15)
                .padding(5)
            }
        }
        .navigationBarHidden(true)
    }
}
