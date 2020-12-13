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
    
    
    init(review: Review) {
        self.review = review
        reviewImages = .init()
        db = .init()
        db.delegate = self
    }
    
    func fetchImages() {
        db.fetchImageFromReview(review: review)
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
}
