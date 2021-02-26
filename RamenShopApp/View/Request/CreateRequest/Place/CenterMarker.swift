//
//  CenterMarker.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-26.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct CenterMarker: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                Spacer()
                Image("shop_icon")
                    .resizable()
                    .frame(width: 25.0, height: 25.0)
                Spacer()
            }
            Spacer()
        }
    }
}
