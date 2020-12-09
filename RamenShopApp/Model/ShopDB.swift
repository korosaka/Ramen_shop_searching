//
//  ShopDB.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-23.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Firebase
import FirebaseFirestore

struct FirebaseHelper {
    let db: Firestore
    
    weak var delegate: CloudFirestoreDelegate?
    
    init() {
        db = Firestore.firestore()
    }
    
    func fetchShops() {
        var shops = [Shop]()
        db.collection("shop").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let name = data["name"] as? String ?? ""
                    let location = data["location"] as! GeoPoint
                    let reviewInfo = data["review_info"] as! [String: Any]
                    shops.append(Shop(shopID: document.documentID,
                                      name: name,
                                      location: location,
                                      aveEvaluation: self.calcAveEvaluation(reviewInfo)))
                }
                self.delegate?.completedFetchingShop(shops: shops)
            }
        }
    }
    
    func fetchLatestReviews(shopID: String) {
        // MARK: to judge to show "more" in LatestReviews in ShopDetailView (only 2reviews will be shown in ShopDetail)
        let numOfReview = 3
        fetchShopReviews(shopID: shopID, limitNum: numOfReview)
    }
    
    func fetchAllReview(shopID: String) {
        fetchShopReviews(shopID: shopID, limitNum: nil)
    }
    
    func fetchShopReviews(shopID: String, limitNum: Int?) {
        let reviewRef = createReviewRef(shopID: shopID)
        
        let completionClosure = { (querySnapshot: QuerySnapshot?, err: Error?) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let reviews = extractReviews(reviewQuery: querySnapshot!)
                self.delegate?.completedFetchingReviews(reviews: reviews)
            }
        }
        
        if limitNum != nil {
            reviewRef
                .order(by: "created_at", descending: true)
                .limit(to: limitNum!)
                .getDocuments(completion: completionClosure)
        } else {
            reviewRef
                .order(by: "created_at", descending: true)
                .getDocuments(completion: completionClosure)
        }
    }
    
    func createReviewRef(shopID: String) -> CollectionReference {
        return db.collection("shop")
            .document(shopID)
            .collection("review")
    }
    
    func extractReviews(reviewQuery: QuerySnapshot) -> [Review] {
        var reviews = [Review]()
        for document in reviewQuery.documents {
            let data = document.data()
            let images = data["picture"] as? [String] ?? [String]()
            let review = Review(reviewID: document.documentID,
                                userID: data["user_id"] as? String ?? "",
                                evaluation: data["evaluation"] as? Int ?? 0,
                                comment: data["comment"] as? String ?? "",
                                imageCount: images.count)
            reviews.append(review)
        }
        return reviews
    }
    
    func fetchPictureReviews(shopID: String) {
        let limitReviewCount = 3
        let reviewStoreRef =
            db.collection("shop")
            .document(shopID)
            .collection("review")
        reviewStoreRef
            .whereField("picture", isNotEqualTo: [String]())
            // MARK: TODO
            //            .order(by: "created_at", descending: true)
            .limit(to: limitReviewCount)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.fetchReviewImages(imageReviews: querySnapshot!)
                }
            }
    }
    
    func fetchReviewImages(imageReviews: QuerySnapshot) {
        
        let storage = Storage.storage()
        var pictures = [UIImage]()
        let totalImageReviewCount = imageReviews.documents.count
        var readImageReviewCount = 0
        
        for document in imageReviews.documents {
            let reviewStorageRef = storage.reference().child("review_picture/\(document.documentID)")
            reviewStorageRef.listAll { (result, error) in
                if let error = error {
                    print("Error getting data: \(error)")
                }
                let totalImageCount = result.items.count
                var readImageCount = 0
                for item in result.items {
                    item.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("Error getting data: \(error)")
                        } else {
                            let image = UIImage(data: data!)
                            pictures.append(image!)
                        }
                        readImageCount += 1
                        if readImageCount == totalImageCount {
                            readImageReviewCount += 1
                            if readImageReviewCount == totalImageReviewCount {
                                self.delegate?.completedFetchingPictures(pictures: pictures)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func calcAveEvaluation(_ reviewInfo: [String: Any]) -> Float {
        let totalEvaluation = reviewInfo["total_point"] as? Int ?? 0
        let reviewCount = reviewInfo["count"] as? Int ?? 0
        
        if totalEvaluation == 0 || reviewCount == 0 {
            return Float(0.0)
        }
        return Float(totalEvaluation) / Float(reviewCount)
    }
}

protocol CloudFirestoreDelegate: class {
    func completedFetchingShop(shops: [Shop])
    func completedFetchingReviews(reviews: [Review])
    func completedFetchingPictures(pictures: [UIImage])
}

// MARK: default implements
extension CloudFirestoreDelegate {
    func completedFetchingShop(shops: [Shop]) {
        print("default implemented completedFetchingShop")
    }
    func completedFetchingReviews(reviews: [Review]) {
        print("default implemented completedFetchingReviews")
    }
    func completedFetchingPictures(pictures: [UIImage]) {
        print("default implemented completedFetchingPictures")
    }
}

struct Shop {
    let shopID: String
    let name: String
    let location: GeoPoint
    let aveEvaluation: Float
    
    func roundEvaluatione() -> String {
        if aveEvaluation == Float(0.0) {
            return "---"
        }
        return String(format: "%.1f", aveEvaluation)
    }
}

struct Review {
    let reviewID: String
    let userID: String
    let evaluation: Int
    let comment: String
    let imageCount: Int
}
