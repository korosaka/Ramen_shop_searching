//
//  UploadingPicture.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-25.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct UploadingPicture: View {
    @EnvironmentObject var viewModel: ReviewingViewModel
    @State var isShowCancelConfirmation = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("You can upload by 3 pictures")
                    .foregroundColor(.navy)
                Spacer()
            }
            HStack {
                Spacer()
                ForEach(0...2, id: \.self) { index in
                    let imageSize = UIScreen.main.bounds.width / 4
                    viewModel.getUploadedImage(index)
                        .scaledToFit()
                        .frame(width: imageSize,
                               height: imageSize)
                        .background(Color.gray)
                    Spacer()
                }
            }
            .upDownPadding(size: 10)
            .background(Color.white)
            .cornerRadius(10)
            
            HStack {
                Spacer()
                Button(action: {
                    viewModel.showMediaSelection()
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Spacer().frame(width: 5)
                        Text("upload picture").bold()
                    }
                }
                .setEnabled(enabled: viewModel.isPicUploadEnabled,
                            defaultColor: .green,
                            padding: 12,
                            radius: 10)
                .sheet(isPresented: $viewModel.isShowSheet) {
                    if viewModel.sheetType == .selectingMedia {
                        MediaSelection()
                    } else {
                        ImagePicker(reviewImages: $viewModel.pictures,
                                    sourceType: viewModel.sourceType)
                    }
                }
                .alert(isPresented: $viewModel.isShowMediaPermissionDenied) {
                    Alert(title: Text("This app has no permission"),
                          message: Text("You need to change setting"),
                          primaryButton: .default(Text("go to setting")) {
                            goToSetting()
                          },
                          secondaryButton: .cancel(Text("cancel")))
                }
                Spacer()
                Button(action: {
                    isShowCancelConfirmation.toggle()
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Spacer().frame(width: 5)
                        Text("cancel upload").bold()
                    }
                }
                .setEnabled(enabled: viewModel.isPicCancelEnabled,
                            defaultColor: .strongRed,
                            padding: 12,
                            radius: 10)
                .alert(isPresented: $isShowCancelConfirmation) {
                    Alert(title: Text("Cencel uploading"),
                          message: Text("Do you remove pictures?"),
                          primaryButton: .default(Text("Yes")) {
                            viewModel.removePictures()
                          },
                          secondaryButton: .cancel(Text("No")))
                }
                Spacer()
            }
        }
    }
}

