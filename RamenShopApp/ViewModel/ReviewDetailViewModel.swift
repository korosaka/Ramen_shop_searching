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
    @Published var pictures: [UIImage]?
    
    
    init(review: Review) {
        self.review = review
        pictures = .init()
        db = .init()
    }
    
    func fetchImages() {
        // MARK: fetch images with review.id
    }
}
