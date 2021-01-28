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
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                Spacer().frame(height: 10)
                Text(viewModel.shopName).largestTitleStyle()
                Spacer().frame(height: 20)
                LocationExplanation()
                    .sidePadding(size: 10)
                Spacer().frame(height: 10)
                SelectingLocation(viewModel: viewModel)
                    .sidePadding(size: 10)
                SendingRequestButton(viewModel: viewModel)
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .navigationBarHidden(true)
    }
}

struct LocationExplanation: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Put the ramen icon on this shop place.\n(Set shop's place on the center of this map)")
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

struct CenterMarker: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                Spacer()
                Image("shop_icon")
                    .resizable()
                    .frame(width: 25.0, height: 25.0)
                Spacer()
            }
            Spacer()
        }
    }
}

struct SendingRequestButton: View {
    @ObservedObject var viewModel: RegisteringShopViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button(action: {
            viewModel.isShowAlert = true
        }) {
            Text("send request")
                .containingSymbolWide(symbol: "paperplane.fill",
                                      color: .strongPink,
                                      textFont: .largeTitle,
                                      symbolFont: .largeTitle)
        }
        .padding(10)
        .alert(isPresented: $viewModel.isShowAlert) {
            if (viewModel.location == nil) {
                return Alert(title: Text("Shop info is insufficient"),
                             message: Text("location data was not got well"),
                             dismissButton: .default(Text("Close")))
            }
            if (!viewModel.isZoomedEnough) {
                return Alert(title: Text("Location is too rough"),
                             message: Text("you must zoom up this map more!"),
                             dismissButton: .default(Text("Close")))
            }
            switch viewModel.activeAlertForName {
            case .confirmation:
                return Alert(title: Text("Confirmation"),
                             message: Text("Are you sure to send this request?"),
                             primaryButton: .default(Text("Yes")) {
                                viewModel.sendShopRequest()
                             },
                             secondaryButton: .cancel(Text("cancel")))
            case .completion:
                return Alert(title: Text("Success"),
                             message: Text("Your request has been sent!"),
                             dismissButton: .default(Text("OK")) {
                                viewModel.resetData()
                                presentationMode.wrappedValue.dismiss()
                             })
            case .error:
                return Alert(title: Text("Failed"),
                             message: Text("Updating request was failed"),
                             dismissButton: .default(Text("OK")) {
                                viewModel.resetData()
                                presentationMode.wrappedValue.dismiss()
                             })
            }
        }
    }
}
