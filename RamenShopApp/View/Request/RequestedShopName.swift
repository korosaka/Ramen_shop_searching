//
//  RequestedShopName.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-24.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct RequestedShopName: View {
    let name: String
    var body: some View {
        VStack {
            Text("shop name")
                .foregroundColor(.black)
                .underline()
            Spacer().frame(height: 5)
            Text(name)
                .largestTitleStyleWithColor(color: .viridianGreen)
        }
    }
}
