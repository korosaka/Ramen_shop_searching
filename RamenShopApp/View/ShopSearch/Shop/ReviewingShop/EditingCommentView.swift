//
//  EditingCommentView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-02-25.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

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
