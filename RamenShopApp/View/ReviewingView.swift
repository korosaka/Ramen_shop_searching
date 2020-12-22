//
//  ReviewingView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-20.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct ReviewingView: View {
    var body: some View {
        
        ScrollView(.vertical) {
            Spacer().frame(height: 10)
            ShopName(shopName: "shop?.name").sidePadding(size: 15)
            Spacer().frame(height: 10)
            StarSelectView().sidePadding(size: 20)
            Spacer().frame(height: 20)
            EditingCommentView(comment: "enter comment")
            Spacer().frame(height: 30)
            UploadingPicture().sidePadding(size: 15)
            Spacer().frame(height: 40)
            DoneButton()
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.blue)
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
    var body: some View {
        HStack {
            Spacer()
            Button(action: {}) {
                Image(systemName: "star")
                    .font(.largeTitle)
                    .foregroundColor(.yellow)
            }
            Spacer()
        }
    }
}

struct EditingCommentView: View {
    private let placeHoler = "enter comment"
    @State var comment: String
    
    var body: some View {
        VStack {
            TextEditor(text: $comment)
                .frame(width: UIScreen.main.bounds.width * 0.9,
                       height: 250)
                .foregroundColor(comment == placeHoler ? .gray : .black)
                .onTapGesture {
                    if comment == placeHoler {
                        comment = ""
                    }
                }
            HStack {
                Spacer()
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Stop editing comment")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(12)
                .background(Color.yellow)
                .cornerRadius(10)
                Spacer()
            }
        }
        
    }
}

struct UploadingPicture: View {
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ForEach(0...2, id: \.self) { index in
                    let imageSize = UIScreen.main.bounds.width / 4
                    
                    Image(systemName: "camera.fill")
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
                Button(action: {}) {
                    Text("Upload picture")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(12)
                .background(Color.green)
                .cornerRadius(10)
                Spacer()
            }
        }
    }
}


struct DoneButton: View {
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {}) {
                Text("Send Review!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(10)
            }
            Spacer()
        }
        .background(Color.red)
        .cornerRadius(20)
        .padding(10)
    }
    
}