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
                Text(Constants.UP_IMAGE_HEADER)
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
                        Text(Constants.UP_IMAGE).bold()
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
                    Alert(title: Text(Constants.NO_PERMISSION_TITLE),
                          message: Text(Constants.NO_PERMISSION_MESSAGE),
                          primaryButton: .default(Text(Constants.GO_SETTING)) {
                            goToSetting()
                          },
                          secondaryButton: .cancel(Text(Constants.CANCEL)))
                }
                Spacer()
                Button(action: {
                    isShowCancelConfirmation.toggle()
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                        Spacer().frame(width: 5)
                        Text(Constants.CANCEL_UPLOAD).bold()
                    }
                }
                .setEnabled(enabled: viewModel.isPicCancelEnabled,
                            defaultColor: .strongRed,
                            padding: 12,
                            radius: 10)
                .alert(isPresented: $isShowCancelConfirmation) {
                    Alert(title: Text(Constants.CANCEL_UPLOAD_TITLE),
                          message: Text(Constants.CANCEL_UPLOAD_MESSAGE),
                          primaryButton: .default(Text(Constants.YES)) {
                            viewModel.removePictures()
                          },
                          secondaryButton: .cancel(Text(Constants.NO)))
                }
                Spacer()
            }
        }
    }
}

