//
//  Pictures.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct Pictures: View {
    let pictures: [UIImage]
    let shopID: String?
    
    var body: some View {
        Text("uploaded pictures")
            .foregroundColor(.white)
            .wideStyle()
            .upDownPadding(size: 3)
            .background(Color.gray)
            .shadow(color: .black, radius: 1)
        Spacer().frame(height: 10)
        if pictures.count > 0 {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    ForEach(0...2, id: \.self) { index in
                        let imageSize = UIScreen.main.bounds.width / 4
                        if pictures.count > index {
                            Image(uiImage: pictures[index])
                                .resizable()
                                .scaledToFit()
                                .frame(width: imageSize,
                                       height: imageSize)
                        } else {
                            Image(systemName: "camera.fill")
                                .frame(width: imageSize,
                                       height: imageSize)
                                .background(Color.gray)
                        }
                        Spacer()
                    }
                }
                .upDownPadding(size: 10)
                .background(Color.white)
                .cornerRadius(10)
                .sidePadding(size: 10)
                
                Spacer().frame(height: 20)
                HStack {
                    Spacer()
                    NavigationLink(destination: AllPictureView(viewModel: .init(shopID: shopID))) {
                        Text("all picture...")
                            .foregroundColor(.seaBlue)
                            .underline()
                    }
                    .sidePadding(size: 10)
                }
            }
        } else {
            Text("there is no picture")
                .foregroundColor(.viridianGreen)
                .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
        }
    }
}
