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
    var review: Review?
    var previousImageCount = 0
    var previousEvaluation: Int?
    var userID: String?
    var createdDate: Date?
    @Published var evaluation: Int
    @Published var comment: String
    @Published var pictures: [UIImage]
    @Published var isShowPhotoLibrary = false
    @Published var isShowPhotoPermissionDenied = false
    @Published var isShowAlert = false
    @Published var activeAlert: ActiveAlert = .confirmation
    @Published var isEditingComment = false
    private let placeHoler = "enter comment"
    var updateReviewPicsState = (uploaded: false, deleted: false)
    var updateReviewState = (review: false, pictures: false, shopEva: false)
    var isPicUploadEnabled: Bool { pictures.count < 3 }
    var isPicCancelEnabled: Bool { pictures.count > 0 }
    var isEnoughInfo: Bool {
        evaluation > 0
            && comment != ""
            && comment != placeHoler
    }
    
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
        isEditingComment = true
    }
    
    func stopEditingComment() {
        if comment == "" {
            comment = placeHoler
        }
        isEditingComment = false
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
    
    func removePictures() {
        pictures.removeAll()
    }
    
    func sendReview() {
        review = Review(reviewID: reviewID ?? UUID().uuidString,
                        userID: userID ?? "",
                        evaluation: evaluation,
                        comment: comment,
                        imageCount: pictures.count,
                        createdDate: Date())
        db.fetchShop(shopID: shop!.shopID) //MARK: to update shop evaluation
        db.updateReviewPics(pics: pictures,
                            reviewID: review!.reviewID,
                            prePicCount: previousImageCount)
        db.updateReview(shopID: shop!.shopID,
                        review: review!)
    }
    
    func checkAlreadySentReview() {
        guard let shopID = shop?.shopID,
              let _userID = userID
        else { return }
        db.fetchUserReview(shopID: shopID, userID: _userID)
    }
    
    func checkReviewPicsStatus() {
        if updateReviewPicsState.uploaded && updateReviewPicsState.deleted {
            updateReviewState.pictures = true
            checkReviewStatus()
        }
    }
    
    func checkReviewStatus() {
        if updateReviewState.review && updateReviewState.pictures && updateReviewState.shopEva {
            leaveReviewing()
            isShowAlert = true
        }
    }
    
    func leaveReviewing() {
        delegate.stopReviewing()
    }
}

extension ReviewingViewModel: AuthenticationDelegate {
    func setUserInfo(user: User) {
        userID = user.uid
        checkAlreadySentReview()
    }
}

extension ReviewingViewModel: FirebaseHelperDelegate {
    func completedFetchingUserReview(reviewID: String, imageCount: Int, evaluation: Int?) {
        self.reviewID = reviewID
        previousImageCount = imageCount
        previousEvaluation = evaluation
    }
    
    func completedUpdatingReview(isSuccess: Bool) {
        if isSuccess {
            activeAlert = .completion
        } else {
            activeAlert = .error
        }
        updateReviewState.review = true
        checkReviewStatus()
    }
    
    func completedUploadingReviewPics() {
        updateReviewPicsState.uploaded = true
        checkReviewPicsStatus()
    }
    func completedDeletingReviewPics() {
        updateReviewPicsState.deleted = true
        checkReviewPicsStatus()
    }
    
    func completedFetchingShop(fetchedShopData: Shop) {
        shop = fetchedShopData
        db.updateShopEvaluation(shopID: shop!.shopID,
                                newEva: review!.evaluation,
                                preEva: previousEvaluation,
                                totalPoint: shop!.totalReview,
                                reviewCount: shop!.reviewCount)
    }
    
    func completedUpdatingShopEvaluation() {
        updateReviewState.shopEva = true
        checkReviewPicsStatus()
    }
}

protocol ReviewingVMDelegate {
    func stopReviewing()
}

enum ActiveAlert {
    case confirmation, completion, error
}
