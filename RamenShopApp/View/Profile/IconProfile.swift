//
//  IconProfile.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct IconProfile: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        VStack {
            viewModel
                .getIconImage()
                .iconLargeStyle()
        }
        .sheet(isPresented: $viewModel.isShowPhotoLibrary,
               content: { ImagePicker(delegate: viewModel) })
        .alert(isPresented: $viewModel.isShowPhotoPermissionDenied) {
            Alert(title: Text("This app has no permission"),
                  message: Text("You need to change setting"),
                  primaryButton: .default(Text("go to setting")) {
                    goToSetting()
                  },
                  secondaryButton: .cancel(Text("cancel")))
        }
    }
}
