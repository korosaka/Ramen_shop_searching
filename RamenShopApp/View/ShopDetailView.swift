//
//  ShopDetailView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-26.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct ShopDetailView: View {
    
    @ObservedObject var viewModel: ShopDetailViewModel
    
    var body: some View {
        ZStack {
            Color.blue
                .cornerRadius(10)
                .padding(5)
                .background(Color.black)
            VStack {
                Text(viewModel.shop?.name ?? "no-name")
                    .foregroundColor(Color.red)
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding(.init(top: 30,
                                   leading: 0,
                                   bottom: 30,
                                   trailing: 0))
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.init(top: 20,
                                   leading: 15,
                                   bottom: 0,
                                   trailing: 15))
                Spacer()
                Text(viewModel.shop?.shopID ?? "no-id")
                    .padding(10)
            }
        }.onAppear() {
            self.viewModel.fetchLatestReview()
        }
    }
}
