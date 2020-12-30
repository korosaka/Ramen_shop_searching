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

//MARK: TODO refactoring
extension Image {
    func symbolIconStyle() -> some View {
        self.resizable()
            .frame(width: 41, height: 41)
    }
    
    func symbolIconLargeStyle() -> some View {
        self.resizable()
            .frame(width: 121, height: 121)
    }
    
    func iconStyle() -> some View {
        self.resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .padding(1)
            .background(Color.black)
            .clipShape(Circle())
    }
    
    func iconLargeStyle() -> some View {
        self.resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .padding(1)
            .background(Color.black)
            .clipShape(Circle())
    }
}

extension View {
    func sidePadding(size: CGFloat) -> some View {
        self.padding(.init(top: 0,
                           leading: size,
                           bottom: 0,
                           trailing: size))
    }
    
    func upDownPadding(size: CGFloat) -> some View {
        self.padding(.init(top: size,
                           leading: 0,
                           bottom: size,
                           trailing: 0))
    }
    
    func goToSetting() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString ) else {
            return
        }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}

// MARK: TODO refactoring
extension Button {
    func setEnabled(enabled: Bool, defaultColor: Color, padding: CGFloat, radius: CGFloat) -> some View {
        if enabled {
            return AnyView(self.padding(padding)
                            .foregroundColor(.white)
                            .background(defaultColor)
                            .cornerRadius(radius))
        } else {
            return AnyView(self.disabled(true)
                            .padding(padding)
                            .foregroundColor(.gray)
                            .background(Color.black)
                            .cornerRadius(radius))
        }
    }
    
    func basicStyle(foreColor: Color, backColor: Color, padding: CGFloat, radius: CGFloat) -> some View {
        return AnyView(self.padding(padding)
                        .foregroundColor(foreColor)
                        .background(backColor)
                        .cornerRadius(radius))
    }
}
