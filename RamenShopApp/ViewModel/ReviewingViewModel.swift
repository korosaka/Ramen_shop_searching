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
import Firebase
class ReviewingViewModel: ObservableObject {
    var db: FirebaseHelper
    var authentication: Authentication
    var shop: Shop?
    var reviewID: String?
    var userID: String?
    var createdDate: Date?
    @Published var evaluation: Int
    @Published var comment: String
    @Published var pictures: [UIImage]
    @Published var isShowPhotoLibrary = false
    @Published var isShowPhotoPermissionDenied = false
    @Published var isShowAlert = false
    @Published var activeAlert: ActiveAlert = .confirmation
    private let placeHoler = "enter comment"
    
    var delegate: ReviewingVMDelegate
    
    init(shop: Shop?, delegate: ReviewingVMDelegate) {
        db = .init()
        authentication = .init()
        evaluation = 0
        comment = placeHoler
        pictures = .init()
        self.shop = shop
        self.delegate = delegate
        db.delegate = self
        authentication.delegate = self
        authentication.checkCurrentUser()
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
            return Image(uiImage: pictures[index]).resizable()
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
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        self.isShowPhotoLibrary = true
                    } else if status == .denied {
                        self.isShowPhotoPermissionDenied = true
                    }
                }
            }
        }
    }
    
    func sendReview() {
        let review = Review(reviewID: reviewID ?? UUID().uuidString,
                            userID: userID ?? "",
                            evaluation: evaluation,
                            comment: comment,
                            imageCount: pictures.count,
                            createdDate: Date())
        db.uploadPictures(pics: pictures, review: review)
        db.uploadReview(shopID: shop!.shopID, review: review)
    }
    
    func checkAlreadySentReview() {
        guard let shopID = shop?.shopID,
              let _userID = userID
        else { return }
        db.fetchUserReview(shopID: shopID, userID: _userID)
    }
}

extension ReviewingViewModel: AuthenticationDelegate {
    func setUserInfo(user: User) {
        userID = user.uid
        checkAlreadySentReview()
    }
}

extension ReviewingViewModel: FirebaseHelperDelegate {
    func completedFetchingUserReview(reviewID: String) {
        self.reviewID = reviewID
    }
    
    func completedUploadingReview(isSuccess: Bool) {
        if isSuccess {
            delegate.completedReviewing() //MARK: reload on ShopDetail
            activeAlert = .completion
        } else {
            activeAlert = .error
        }
        isShowAlert = true
    }
}

protocol ReviewingVMDelegate {
    func completedReviewing()
}

enum ActiveAlert {
    case confirmation, completion, error
}
