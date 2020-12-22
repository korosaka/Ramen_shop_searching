//
//  ReviewingViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-21.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import SwiftUI
class ReviewingViewModel: ObservableObject {
    var shopID: String?
    var userID: String?
    var createdDate: Date?
    @Published var evaluation = 0
    @Published var comment = ""
    @Published var pictures = [Image]()
    
    func setEvaluation(num: Int) {
        evaluation = num
    }
    
    func getStarImage(num: Int) -> Image {
        if num > evaluation {
            return Image(systemName: "star")
        } else {
            return Image(systemName: "star.fill")
        }
    }
}
