//
//  OriginalHeaderView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-27.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct CustomNavigationBar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let additionalAction: (() -> Void)?
    var body: some View {
        HStack {
            Button(action: {
                if let _additionalAction = additionalAction { _additionalAction() }
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack(spacing: 0) {
                    Image(systemName: "chevron.backward").sidePadding(size: 3).font(.headline)
                    Text(Constants.BACK).font(.headline)
                }.upDownPadding(size: 12)
            }
            Spacer()
        }
        .background(Color.white)
    }
}
