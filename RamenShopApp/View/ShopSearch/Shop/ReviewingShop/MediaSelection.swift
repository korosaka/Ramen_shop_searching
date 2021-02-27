//
//  MediaSelection.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-25.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct MediaSelection: View {
    @EnvironmentObject var viewModel: ReviewingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(Constants.CANCEL)
                }
                .padding(10)
                Spacer()
            }
            .background(Color.superWhitePasteGreen)
            Spacer()
            Button(action: {
                viewModel.utilizePhotoLibrary()
            }) {
                Text(Constants.LIBRARY)
            }
            Spacer().frame(height: 50)
            Button(action: {
                viewModel.utilizeCamera()
            }) {
                Text(Constants.CAMERA)
            }
            Spacer()
        }
    }
}
