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
            .sidePadding(size: 20)
    }
}

extension TextField {
    func basicStyle() -> some View {
        self.modifier(BasicTextField())
    }
}

//MARK: TODO refactoring like Button.basicStyle
extension Text {
    func basicButtonTextStyle(_ foreColor: Color, _ backColor: Color) -> some View {
        self.font(.title)
            .bold()
            .foregroundColor(foreColor)
            .upDownPadding(size: 10)
            .frame(maxWidth: .infinity)
            .border(Color.black, width: 2)
            .background(backColor)
            .sidePadding(size: 20)
    }
    
    func containingSymbol(symbol: String, color: Color, textFont: Font, symbolFont: Font) -> some View {
        HStack {
            self.bold().font(textFont)
            Image(systemName: symbol).font(symbolFont)
        }
        .foregroundColor(.white)
        .upDownPadding(size: 8)
        .sidePadding(size: 25)
        .background(color)
        .cornerRadius(20)
        .shadow(color: .black, radius: 2, x: 1, y: 1)
    }
    
    func containingSymbolDisable(symbol: String, textFont: Font, symbolFont: Font) -> some View {
        HStack {
            self.bold().font(textFont)
            Image(systemName: symbol).font(symbolFont)
        }
        .foregroundColor(.gray)
        .upDownPadding(size: 8)
        .sidePadding(size: 25)
        .background(Color.pastelGray)
        .cornerRadius(20)
    }
    
    func containingSymbolWide(symbol: String, color: Color, textFont: Font, symbolFont: Font) -> some View {
        HStack {
            Spacer()
            self.bold().font(textFont)
            Spacer().frame(width: 15)
            Image(systemName: symbol).font(symbolFont)
            Spacer()
        }
        .foregroundColor(.white)
        .upDownPadding(size: 8)
        .background(color)
        .cornerRadius(20)
        .shadow(color: .black, radius: 2, x: 1, y: 1)
    }
    
    func containingSymbolDisableWide(symbol: String, textFont: Font, symbolFont: Font) -> some View {
        HStack {
            Spacer()
            self.bold().font(textFont)
            Spacer().frame(width: 15)
            Image(systemName: symbol).font(symbolFont)
            Spacer()
        }
        .foregroundColor(.gray)
        .upDownPadding(size: 8)
        .background(Color.pastelGray)
        .cornerRadius(20)
    }
    
    //MARK: TODO replace with largestTitleStyleWithColor(color: .strongRed)
    func largestTitleStyle() -> some View {
        largestTitleStyleWithColor(color: .strongRed)
    }
    
    func largestTitleStyleWithColor(color: Color) -> some View {
        self
            .foregroundColor(color)
            .font(.system(size: 35, weight: .black, design: .default))
            .italic()
            .bold()
            .shadow(color: .black, radius: 2, x: 2, y: 2)
    }
    
    func middleTitleStyle() -> some View {
        self
            .font(.title)
            .bold()
            .foregroundColor(.white)
            .shadow(color: .black, radius: 2, x: 2, y: 2)
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

extension Image {
    func iconSmallStyle() -> some View {
        iconStyle(size: 50)
    }
    
    func iconLargeStyle() -> some View {
        iconStyle(size: 120)
    }
    
    func iconStyle(size: CGFloat) -> some View {
        self.resizable()
            .scaledToFill()
            .foregroundColor(.gray)
            .background(Color.white)
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
    
    func circleSymbol(font: Font, fore: Color, back: Color) -> some View {
        self.font(font)
            .foregroundColor(fore)
            .padding(8)
            .background(back)
            .clipShape(Circle())
            .shadow(color: .black, radius: 2, x: 1, y: 1)
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
    
    //MARK: TODO use anywhere!!
    func wideStyle()  -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
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
                            .cornerRadius(radius)
                            .shadow(color: .black, radius: 2, x: 1, y: 1))
        } else {
            return AnyView(self.disabled(true)
                            .padding(padding)
                            .foregroundColor(.gray)
                            .background(Color.pastelGray)
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

extension Color {
    static var darkGray: Color { return Color.init(red: 51 / 255, green: 51 / 255, blue: 51 / 255) }
    static var pastelGray: Color { return Color.init(red: 204 / 255, green: 204 / 255, blue: 204 / 255) }
    static var pastelRed: Color { return Color.init(red: 255 / 255, green: 163 / 255, blue: 209 / 255) }
    static var viridianGreen: Color { return Color.init(red: 0 / 255, green: 136 / 255, blue: 90 / 255) }
    static var pastelGreen: Color { return Color.init(red: 127 / 255, green: 255 / 255, blue: 127 / 255) }
    static var whitePasteGreen: Color { return Color.init(red: 173 / 255, green: 255 / 255, blue: 214 / 255) }
    static var superWhitePasteGreen: Color { return Color.init(red: 224 / 255, green: 255 / 255, blue: 224 / 255) }
    static var navy: Color { return Color.init(red: 0 / 255, green: 0 / 255, blue: 204 / 255) }
    static var strongRed: Color { return Color.init(red: 255 / 255, green: 0 / 255, blue: 0 / 255) }
    static var strongPink: Color { return Color.init(red: 255 / 255, green: 0 / 255, blue: 127 / 255) }
    static var pastelPink: Color { return Color.init(red: 255 / 255, green: 188 / 255, blue: 255 / 255) }
    static var skyBlue: Color { return Color.init(red: 0 / 255, green: 255 / 255, blue: 255 / 255) }
    static var seaBlue: Color { return Color.init(red: 0 / 255, green: 127 / 255, blue: 255 / 255) }
    static var gold: Color { return Color.init(red: 255 / 255, green: 215 / 255, blue: 0 / 255) }
    static var pastelYellow: Color { return Color.init(red: 255 / 255, green: 255 / 255, blue: 127 / 255) }
}
