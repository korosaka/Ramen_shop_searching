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
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                CustomNavigationBar {
                    viewModel.leaveReviewing()
                }
                ScrollView(.vertical) {
                    Spacer().frame(height: 10)
                    ShopName(shopName: viewModel.shop?.name)
                    Spacer().frame(height: 20)
                    StarSelectView()
                        .sidePadding(size: 20)
                    Spacer().frame(height: 20)
                    EditingCommentView()
                    Spacer().frame(height: 50)
                    UploadingPicture()
                        .sidePadding(size: 10)
                    Spacer().frame(height: 40)
                    DoneButton()
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .navigationBarHidden(true)
    }
}

struct StarSelectView: View {
    var body: some View {
        VStack {
            Text("your evaluation")
                .font(.headline)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2, x: 2, y: 2)
            Spacer().frame(height: 10)
            HStack {
                CustomStarButton(starNumber: 1)
                CustomStarButton(starNumber: 2)
                CustomStarButton(starNumber: 3)
                CustomStarButton(starNumber: 4)
                CustomStarButton(starNumber: 5)
            }
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
                    .foregroundColor(.gold)
                    .shadow(color: .black, radius: 1.5)
            }
            Spacer()
        }
    }
}

struct EditingCommentView: View {
    @EnvironmentObject var viewModel: ReviewingViewModel
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        VStack {
            TextEditor(text: $viewModel.comment)
                .background(Color.white)
                .frame(width: UIScreen.main.bounds.width * 0.95,
                       height: 250)
                .cornerRadius(10)
                .foregroundColor(viewModel.getCommentFontColor())
                .onTapGesture { viewModel.onTapComment() }
            HStack {
                Spacer()
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    viewModel.stopEditingComment()
                }) {
                    HStack {
                        Image(systemName: "pencil.slash")
                        Spacer().frame(width: 5)
                        Text("stop editing").bold()
                    }
                    .sidePadding(size: 10)
                }
                .setEnabled(enabled: viewModel.isEditingComment,
                            defaultColor: .strongRed,
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


struct DoneButton: View {
    @EnvironmentObject var viewModel: ReviewingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            viewModel.activeAlert = .confirmation
            viewModel.isShowAlert = true
        }) {
            HStack {
                Spacer()
                Image(systemName: "paperplane.fill")
                    .font(.largeTitle)
                Spacer().frame(width: 20)
                Text("send review")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
        }
        .setEnabled(enabled: viewModel.isEnoughInfo,
                    defaultColor: .strongPink,
                    padding: 10,
                    radius: 20)
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

enum ReviewingSheetType {
    case selectingMedia, utilizingMedia
}
