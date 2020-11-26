//
//  Modifiers.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-12.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct BasicTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.init(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}

extension TextField {
    func basicStyle() -> some View {
        self.modifier(BasicTextField())
    }
}

extension Text {
    func basicButtonTextStyle(_ foreColor: Color, _ backColor: Color) -> some View {
        self.font(.title)
            .bold()
            .foregroundColor(foreColor)
            .padding(.init(top: 10,
                           leading: 0,
                           bottom: 10,
                           trailing: 0))
            .frame(maxWidth: .infinity)
            .border(Color.black, width: 2)
            .background(backColor)
            .padding(.init(top: 0,
                           leading: 20,
                           bottom: 0,
                           trailing: 20))
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
