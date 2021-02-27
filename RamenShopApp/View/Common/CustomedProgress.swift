//
//  CustomedProgress.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct CustomedProgress: View {
    var body: some View {
        ProgressView(Constants.PROCESSING)
            .foregroundColor(.viridianGreen)
            .upDownPadding(size: 15)
            .wideStyle()
            .background(Color.superWhitePasteGreen)
            .cornerRadius(20)
            .sidePadding(size: 30)
    }
}
