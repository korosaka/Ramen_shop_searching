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
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                VStack(spacing: 0) {
                    RequestingTitleBar()
                    Text("shop: \(viewModel.shopName)")
                        .font(.title)
                        .foregroundColor(.white)
                        .bold()
                    HStack {
                        Spacer()
                        Text("Put the ramen icon on this shop place")
                            .foregroundColor(.yellow)
                        Spacer()
                    }
                    Text("(Set shop's place on the center of this map)")
                        .foregroundColor(.white)
                }
                .background(Color.blue)
                ZStack {
                    GoogleMapView(registeringShopVM: viewModel)
                    CenterMarker()
                }
                .padding(5)
                .background(Color.blue)
                Button(action: {
                    viewModel.isShowAlert = true
                }) {
                    HStack {
                        Spacer()
                        Text("Done").bold()
                        Spacer()
                    }
                }
                .basicStyle(foreColor: .white, backColor: .red, padding: 10, radius: 10)
                .padding(10)
                .alert(isPresented: $viewModel.isShowAlert) {
                    if (viewModel.location == nil) {
                        return Alert(title: Text("Shop info is insufficient"),
                                     message: Text("location data was not got well"),
                                     dismissButton: .default(Text("Close")))
                    }
                    if (!viewModel.isZoomedEnough) {
                        return Alert(title: Text("Location is abstract"),
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
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
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
                    .frame(width: 25.0, height: 25.0)
                Spacer()
            }
            Spacer()
        }
    }
}
