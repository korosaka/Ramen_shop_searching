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
    let firestore: Firestore
    let storage: Storage
    
    weak var delegate: FirebaseHelperDelegate?
    
    init() {
        firestore = Firestore.firestore()
        storage = Storage.storage()
    }
    
    func fetchShops() {
        var shops = [Shop]()
        firestore.collection("shop").getDocuments() { (querySnapshot, err) in
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
        return firestore.collection("shop")
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
            firestore.collection("shop")
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
                    self.fetchImageFromReviewDocs(imageReviewsQS: querySnapshot!)
                }
            }
    }
    
    // MARK: to get images of a shop (used for ShopDetail)
    func fetchImageFromReviewDocs(imageReviewsQS: QuerySnapshot) {
        var totalPictures = [UIImage]()
        let totalImageReviewCount = imageReviewsQS.documents.count
        var readImageReviewCount = 0
        
        let completionClosure = { (pictures: [UIImage]) -> Void in
            totalPictures += pictures
            readImageReviewCount += 1
            // MARK: completed getting images of every review?
            if readImageReviewCount == totalImageReviewCount {
                self.delegate?.completedFetchingPictures(pictures: totalPictures)
            }
        }
        
        for reviewDoc in imageReviewsQS.documents {
            fetchReviewImage(id: reviewDoc.documentID, completion: completionClosure)
        }
    }
    
    // MARK: to get images of a review (used for ReviewDetail)
    func fetchImageFromReview(review: Review) {
        let completionClosure = { (pictures: [UIImage]) -> Void in
            self.delegate?.completedFetchingPictures(pictures: pictures)
        }
        fetchReviewImage(id: review.reviewID, completion: completionClosure)
    }
    
    private func fetchReviewImage(id reviewID: String, completion: @escaping ([UIImage]) -> Void) {
        var reviewImages = [UIImage]()
        let reviewStorageRef = storage.reference().child("review_picture/\(reviewID)")
        reviewStorageRef.listAll { (result, error) in
            // MARK: asynchronous
            if let error = error {
                print("Error getting data: \(error)")
            }
            let totalImageCount = result.items.count
            var readImageCount = 0
            for item in result.items {
                item.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    // MARK: asynchronous
                    if let error = error {
                        print("Error getting data: \(error)")
                    } else {
                        let image = UIImage(data: data!)
                        reviewImages.append(image!)
                    }
                    readImageCount += 1
                    // MARK: completed getting images of 1 review?
                    if readImageCount == totalImageCount {
                        completion(reviewImages)
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

protocol FirebaseHelperDelegate: class {
    func completedFetchingShop(shops: [Shop])
    func completedFetchingReviews(reviews: [Review])
    func completedFetchingPictures(pictures: [UIImage])
}

// MARK: default implements
extension FirebaseHelperDelegate {
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
