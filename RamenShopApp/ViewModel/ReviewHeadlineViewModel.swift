//
//  ReviewHeadlineViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-19.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
class ReviewHeadlineViewModel: ObservableObject {
    let review: Review
    var db: FirebaseHelper
    @Published var userProfile: Profile
    
    init(review: Review) {
        self.review = review
        userProfile = Profile(userName: "unnamed")
        db = .init()
        db.delegate = self
    }
    
    func fetchProfile() {
        db.fetchUserProfile(userID: review.userID)
    }
}

extension ReviewHeadlineViewModel: FirebaseHelperDelegate {
    func completedFetchingProfile(profile: Profile) {
        userProfile = profile
        print("got profile data: \(userProfile)")
    }
}
