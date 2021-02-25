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
                    Text("Cancel")
                }
                .padding(10)
                Spacer()
            }
            .background(Color.superWhitePasteGreen)
            Spacer()
            Button(action: {
                viewModel.utilizePhotoLibrary()
            }) {
                Text("Photo Library")
            }
            Spacer().frame(height: 50)
            Button(action: {
                viewModel.utilizeCamera()
            }) {
                Text("Camera")
            }
            Spacer()
        }
    }
}
