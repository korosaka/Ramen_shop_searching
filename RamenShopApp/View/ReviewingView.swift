//
//  ReviewingView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-20.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct ReviewingView: View {
    @EnvironmentObject var viewModel: ReviewingViewModel
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar {
                viewModel.leaveReviewing()
            }
            ScrollView(.vertical) {
                Spacer().frame(height: 10)
                ShopName(shopName: viewModel.shop?.name)
                    .sidePadding(size: 15)
                Spacer().frame(height: 10)
                StarSelectView()
                    .sidePadding(size: 20)
                Spacer().frame(height: 20)
                EditingCommentView()
                Spacer().frame(height: 30)
                UploadingPicture()
                    .sidePadding(size: 15)
                Spacer().frame(height: 40)
                DoneButton()
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.blue)
        }
        .navigationBarHidden(true)
    }
}

struct StarSelectView: View {
    var body: some View {
        VStack {
            Text("Your Evaluation!")
                .font(.headline)
                .foregroundColor(.white)
            HStack {
                CustomStarButton(starNumber: 1)
                CustomStarButton(starNumber: 2)
                CustomStarButton(starNumber: 3)
                CustomStarButton(starNumber: 4)
                CustomStarButton(starNumber: 5)
            }.background(Color.white)
        }
        
    }
}

struct CustomStarButton: View {
    let starNumber: Int
    @EnvironmentObject var viewModel: ReviewingViewModel
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.setEvaluation(num: starNumber)
            }) {
                viewModel.getStarImage(num: starNumber)
                    .font(.largeTitle)
                    .foregroundColor(.yellow)
            }
            Spacer()
        }
    }
}

struct EditingCommentView: View {
    @EnvironmentObject var viewModel: ReviewingViewModel
    var body: some View {
        VStack {
            TextEditor(text: $viewModel.comment)
                .frame(width: UIScreen.main.bounds.width * 0.9,
                       height: 250)
                .foregroundColor(viewModel.getCommentFontColor())
                .onTapGesture { viewModel.onTapComment() }
            HStack {
                Spacer()
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    viewModel.stopEditingComment()
                }) {
                    Text("Stop editing comment")
                        .font(.headline)
                        .bold()
                }
                .setEnabled(enabled: viewModel.isEditingComment,
                            defaultColor: .yellow,
                            padding: 12,
                            radius: 10)
                Spacer()
            }
        }
        
    }
}

struct UploadingPicture: View {
    @EnvironmentObject var viewModel: ReviewingViewModel
    @State var isShowCancelConfirmation = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("You can upload by 3 pictures")
                    .foregroundColor(.white)
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
                    viewModel.checkPhotoPermission()
                }) {
                    Text("Upload picture")
                        .font(.headline)
                        .bold()
                }
                .setEnabled(enabled: viewModel.isPicUploadEnabled,
                            defaultColor: .green,
                            padding: 12,
                            radius: 10)
                //MARK: TODO is sourceType not needed?
                .sheet(isPresented: $viewModel.isShowPhotoLibrary,
                       content: { ImagePicker(reviewImages: $viewModel.pictures) })
                .alert(isPresented: $viewModel.isShowPhotoPermissionDenied) {
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
                    Text("Cancel upload")
                        .font(.headline)
                        .bold()
                }.setEnabled(enabled: viewModel.isPicCancelEnabled,
                             defaultColor: .orange,
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
    
    func goToSetting() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString ) else {
            return
        }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}


struct DoneButton: View {
    @EnvironmentObject var viewModel: ReviewingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.activeAlert = .confirmation
                viewModel.isShowAlert = true
            }) {
                Text("Send Review!")
                    .font(.largeTitle)
                    .bold()
            }
            .setEnabled(enabled: viewModel.isEnoughInfo,
                        defaultColor: .red,
                        padding: 10,
                        radius: 20)
            Spacer()
        }
        .padding(10)
        .alert(isPresented: $viewModel.isShowAlert) {
            switch viewModel.activeAlert {
            case .confirmation:
                return Alert(title: Text("Final confirmation"),
                             message: Text("Will you send this review?"),
                             primaryButton: .default(Text("Yes")) {
                                viewModel.sendReview()
                             },
                             secondaryButton: .cancel(Text("cancel")))
            case .completion:
                return Alert(title: Text("Success"),
                             message: Text("Your review has been done"),
                             dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                             })
            case .error:
                return Alert(title: Text("Failed"),
                             message: Text("Uploading this review was failed"),
                             dismissButton: .default(Text("OK")) {
                                presentationMode.wrappedValue.dismiss()
                             })
            }
        }
    }
    
}
