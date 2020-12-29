//
//  ProfileSettingView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-29.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct ProfileSettingView: View {
    @ObservedObject var viewModel: ProfileSettingViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(additionalAction: nil)
            Spacer().frame(height: 30)
            viewModel.getIconImage()
            Spacer().frame(height: 10)
            Button(action: {}) {
                Text("change icon image")
            }
            Spacer().frame(height: 30)
            Text(viewModel.getUserName())
                .font(.title)
                .bold()
                .foregroundColor(.white)
            Spacer().frame(height: 10)
            HStack {
                Spacer()
                Button(action: {}) {
                    Text("change name")
                }
                Spacer().frame(width: 40)
                Button(action: {}) {
                    Text("done")
                }
                Spacer()
            }
            Spacer()
        }
        .background(Color.green)
        .navigationBarHidden(true)
    }
}
