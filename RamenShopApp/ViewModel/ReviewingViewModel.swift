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
    @Published var evaluation: Int
    @Published var comment: String
    @Published var pictures: [Image]
    private let placeHoler = "enter comment"
    
    init() {
        evaluation = 0
        comment = placeHoler
        pictures = .init()
    }
    
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
    
    func getCommentFontColor() -> Color {
        return comment == placeHoler ? .gray : .black
    }
    
    func onTapComment() {
        if comment == placeHoler {
            comment = ""
        }
    }
    
    func stopEditingComment() {
        if comment == "" {
            comment = placeHoler
        }
    }
    
    func getUploadedImage(_ index: Int) -> Image {
        if pictures.count > index {
            return pictures[index].resizable()
        } else {
            return Image(systemName: "camera.fill")
        }
    }
}
