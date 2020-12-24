//
//  ReviewingViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-21.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import SwiftUI
import Photos
class ReviewingViewModel: ObservableObject {
    var shopID: String?
    var userID: String?
    var createdDate: Date?
    @Published var evaluation: Int
    @Published var comment: String
    @Published var pictures: [Image]
    @Published var isShowPhotoLibrary = false
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
    
    func checkPhotoPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if status == .authorized || status == .limited {
            isShowPhotoLibrary = true
        } else {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                if status == .authorized || status == .limited {
                    self.isShowPhotoLibrary = true
                } else if status == .denied {
                    print("PHPhotoLibrary can not be used")
                }
            }
        }
    }
}
