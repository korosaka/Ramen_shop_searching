//
//  ShopsMapView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-02.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import SwiftUI

struct ShopsMapView: View {
    @ObservedObject var viewModel: ShopsMapViewModel
    
    var body: some View {
        ZStack {
            BackGroundView()
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    GoogleMapView(shopsMapVM: viewModel)
                        .cornerRadius(20)
                        .padding(5)
                    
                    Button(action: {
                        self.viewModel.loadShops()
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .circleSymbol(font: .title3,
                                          fore: .white,
                                          back: .strongPink)
                            .padding(10)
                    }
                }
                Spacer().frame(height: 5)
                EvaluationFilter(viewModel: viewModel)
                    .sidePadding(size: 5)
                Spacer().frame(height: 20)
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
            NavigationLink(destination: ShopDetailView(viewModel: .init(mapVM: self.viewModel)),
                           isActive: $viewModel.isShopSelected) {
                EmptyView()
            }
        }
    }
}

struct EvaluationFilter: View {
    @ObservedObject var viewModel: ShopsMapViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("evaluation filter")
                .foregroundColor(.viridianGreen)
                .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
            Picker(selection: $viewModel.evaluationFilter, label: Text("EvaFilter"), content: {
                Text("---").tag(-1)
                ForEach(0..<viewModel.filterValues.count, id: \.self) { index in
                    Text(String(viewModel.filterValues[index])).tag(index)
                }
            })
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

//MARK: TODO
//struct ReloadButton: View {
//    let buttonAction: ()
//    var body: some View {
//        Button(action: {
//            buttonAction
//        }) {
//            Text("reload")
//                .containingSymbol(symbol: "arrow.triangle.2.circlepath",
//                                  color: .strongPink,
//                                  textFont: .title3,
//                                  symbolFont: .title3)
//        }
//    }
//}
