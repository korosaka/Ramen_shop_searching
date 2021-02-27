//
//  AllPictureViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-17.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import SwiftUI
class AllPictureViewModel: ObservableObject {
    
    @Published var allImages: [RamenImage]
    @Published var isShowingProgress = false
    var db: DatabaseHelper
    var shopID: String?
    
    init(shopID: String?) {
        db = .init()
        self.shopID = shopID
        allImages = .init()
        db.delegate = self
    }
    
    func fetchAllImage() {
        guard let _id = shopID else { return print("error in AllPictureViewModel") }
        isShowingProgress = true
        db.fetchPictureReviews(shopID: _id, limit: nil)
    }
}

extension AllPictureViewModel: FirebaseHelperDelegate {
    func completedFetchingPictures(pictures: [UIImage], shopID: String?) {
        isShowingProgress = false
        allImages.removeAll()
        pictures.forEach { picture in
            let ramenImage = RamenImage(picture: Image(uiImage: picture))
            allImages.append(ramenImage)
        }
    }
}
