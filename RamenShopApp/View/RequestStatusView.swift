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
            HStack {
                Spacer()
                Text("Your request's status to add new shop")
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
            }.background(Color.orange)
            
            if viewModel.hasRequest {
                VStack {
                    HStack {
                        Spacer()
                        Text("Your Request")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    Spacer().frame(height: 30)
                    VStack {
                        Text("Shop Name")
                            .foregroundColor(.black)
                            .underline()
                        Spacer().frame(height: 5)
                        Text(viewModel.shopName!)
                            .font(.title)
                            .bold()
                            .foregroundColor(.red)
                    }
                    Spacer().frame(height: 50)
                    VStack {
                        Text("Inspection Status")
                            .foregroundColor(.black)
                            .underline()
                        Spacer().frame(height: 5)
                        Text(viewModel.inspectionStatus!.getStatus())
                            .font(.title)
                            .bold()
                            .foregroundColor(.red)
                        Text(viewModel.inspectionStatus!.getSubMessage())
                    }
                    Spacer()
                    Button(action: {
                        //MARK: TODO
                    }) {
                        HStack {
                            Spacer()
                            Text(viewModel.inspectionStatus!.getButtonMessage())
                                .font(.title)
                                .bold()
                            Spacer()
                        }
                    }
                    .basicStyle(foreColor: .white,
                                backColor: .blue,
                                padding: 10,
                                radius: 15)
                    .padding(20)
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(20)
            } else {
                Spacer()
                Text("You have no request now").foregroundColor(.white)
                Spacer()
            }
        }
        .background(Color.green)
        .navigationBarHidden(true)
    }
}

