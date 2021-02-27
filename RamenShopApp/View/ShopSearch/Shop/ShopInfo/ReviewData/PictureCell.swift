//
//  PictureCell.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-25.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct PictureCell: View {
    let ramenImage: RamenImage
    let size: CGFloat
    
    var body: some View {
        ramenImage.picture
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .background(Color.white)
            .border(Color.green)
    }
}
