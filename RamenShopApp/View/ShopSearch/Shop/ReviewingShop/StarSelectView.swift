//
//  StarSelectView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-25.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

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
