//
//  RegisteringShopNameView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-02.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RegisteringShopNameView: View {
    @ObservedObject var viewModel: RegisteringShopViewModel
    var body: some View {
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                Spacer().frame(height: 15)
                Text("New Shop Request").middleTitleStyle()
                Spacer().frame(height: 40)
                RequestExplanation().sidePadding(size: 10)
                Spacer().frame(height: 40)
                EnteringShopName(viewModel: viewModel)
                Spacer()
                NavigationToMap(viewModel: viewModel)
                    .sidePadding(size: 10)
                Spacer().frame(height: 10)
            }
        }
    }
}

struct RequestExplanation: View {
    let explanation = "You can add your favorite Ramen-Shop to this app by just entering shop's name and location.\nReviewing your request will be done within a few days.\nIf your request is approved, the shop will be added to this app."
    var body: some View {
        HStack {
            Spacer()
            Text(explanation)
                .bold()
                .foregroundColor(.white)
                .padding(10)
            Spacer()
        }
        .background(Color.viridianGreen)
        .cornerRadius(20)
        .shadow(color: .black, radius: 3, x: 2, y: 2)
    }
}

struct EnteringShopName: View {
    @ObservedObject var viewModel: RegisteringShopViewModel
    var body: some View {
        VStack {
            Text("shop name")
                .font(.title)
                .bold()
                .foregroundColor(.strongPink)
                .shadow(color: .black, radius: 1, x: 1, y: 1)
            Spacer().frame(height: 10)
            TextField("enter shop name", text: $viewModel.shopName)
                .basicStyle().font(.title)
        }
    }
}

struct NavigationToMap: View {
    @ObservedObject var viewModel: RegisteringShopViewModel
    var body: some View {
        NavigationLink(destination: RegisteringShopPlaceView(viewModel: self.viewModel)) {
            if viewModel.isNameSet {
                Text("set location")
                    .containingSymbolWide(symbol: "mappin.and.ellipse",
                                          color: .strongPink,
                                          textFont: .title,
                                          symbolFont: .title3)
            } else {
                Text("set location")
                    .containingSymbolDisableWide(symbol: "mappin.and.ellipse",
                                                 textFont: .title,
                                                 symbolFont: .title3)
            }
        }
        .disabled(!viewModel.isNameSet)
    }
}
