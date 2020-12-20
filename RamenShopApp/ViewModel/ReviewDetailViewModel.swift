//
//  ReviewDetailViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-09.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI
class ReviewDetailViewModel: ObservableObject {
    
    var review: Review
    var db: FirebaseHelper
    @Published var reviewImages: [RamenImage]
    @Published var userProfile: Profile
    
    
    init(review: Review) {
        self.review = review
        reviewImages = .init()
        db = .init()
        userProfile = Profile(userName: "unnamed")
        db.delegate = self
        fetchImages()
        fetchProfile()
    }
    
    func fetchImages() {
        db.fetchImageFromReview(review: review)
    }
    
    func fetchProfile() {
        db.fetchUserProfile(userID: review.userID)
    }
}

extension ReviewDetailViewModel: FirebaseHelperDelegate {
    func completedFetchingPictures(pictures: [UIImage]) {
        reviewImages.removeAll()
        pictures.forEach { picture in
            let ramenImage = RamenImage(picture: Image(uiImage: picture))
            reviewImages.append(ramenImage)
        }
    }
    
    func completedFetchingProfile(profile: Profile) {
        userProfile = profile
    }
}
