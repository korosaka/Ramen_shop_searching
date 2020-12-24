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
        
        let completionHandler = { (querySnapshot: QuerySnapshot?, err: Error?) in
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
                .getDocuments(completion: completionHandler)
        } else {
            reviewRef
                .order(by: "created_at", descending: true)
                .getDocuments(completion: completionHandler)
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
            let createdTimestamp = data["created_at"] as? Timestamp
            let review = Review(reviewID: document.documentID,
                                userID: data["user_id"] as? String ?? "",
                                evaluation: data["evaluation"] as? Int ?? 0,
                                comment: data["comment"] as? String ?? "",
                                imageCount: data["image_number"] as? Int ?? 0,
                                createdDate: createdTimestamp!.dateValue())
            reviews.append(review)
        }
        return reviews
    }
    
    func fetchUserProfile(userID: String) {
        let userRef = firestore.collection("user")
            .document(userID)
        
        userRef.getDocument { (document, error) in
            if error != nil {
                return print("error happened in fetchUserProfile !!")
            }
            var profile = Profile(userName: "unnamed", icon: nil)
            if let data = document?.data() {
                profile.userName = data["user_name"] as? String ?? "unnamed"
                let hasIcon = data["has_icon"] as? Bool ?? false
                if hasIcon {
                    fetchUserIcon(userID, profile)
                } else {
                    delegate?.completedFetchingProfile(profile: profile)
                }
            } else {
                delegate?.completedFetchingProfile(profile: profile)
                return
            }
        }
    }
    
    fileprivate func fetchUserIcon(_ userID: String, _ profile: Profile) {
        let iconStorageRef = storage.reference().child("user_icon/\(userID)")
        let completionHandler = { (result: StorageListResult, error: Error?) -> Void in
            // MARK: asynchronous
            if error != nil {
                delegate?.completedFetchingProfile(profile: profile)
                return print("error happened in fetchUserIcon !!")
            }
            let iconRef: StorageReference? = result.items[0]
            if iconRef != nil {
                iconRef!.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    // MARK: asynchronous
                    if let error = error {
                        print("Error getting data: \(error)")
                        delegate?.completedFetchingProfile(profile: profile)
                    } else {
                        let iconProfile = Profile(userName: profile.userName, icon: UIImage(data: data!))
                        delegate?.completedFetchingProfile(profile: iconProfile)
                    }
                }
            } else {
                delegate?.completedFetchingProfile(profile: profile)
                return
            }
        }
        
        iconStorageRef.list(withMaxResults: 1, completion: completionHandler)
    }
    
    func fetchPictureReviews(shopID: String, limit: Int?) {
        let reviewStoreRef =
            firestore.collection("shop")
            .document(shopID)
            .collection("review")
        var pictureReviewRef = reviewStoreRef.whereField("image_number", isGreaterThan: 0)
        // MARK: TODO .order(by: "created_at", descending: true)
        if let _limit = limit {
            pictureReviewRef = pictureReviewRef.limit(to: _limit)
        }
        pictureReviewRef.getDocuments() { (querySnapshot, err) in
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
        
        let completionHandler = { (pictures: [UIImage]) -> Void in
            totalPictures += pictures
            readImageReviewCount += 1
            // MARK: completed getting images of every review?
            if readImageReviewCount == totalImageReviewCount {
                self.delegate?.completedFetchingPictures(pictures: totalPictures)
            }
        }
        
        for reviewDoc in imageReviewsQS.documents {
            fetchReviewImage(id: reviewDoc.documentID, completion: completionHandler)
        }
    }
    
    // MARK: to get images of a review (used for ReviewDetail)
    func fetchImageFromReview(review: Review) {
        let completionHandler = { (pictures: [UIImage]) -> Void in
            self.delegate?.completedFetchingPictures(pictures: pictures)
        }
        fetchReviewImage(id: review.reviewID, completion: completionHandler)
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
    
    
    func uploadReview(shopID: String, review: Review) {
        let timeStamp: Timestamp = .init(date: review.createdDate)
        let reviewRef = firestore
            .collection("shop")
            .document(shopID)
            .collection("review")
            .document(review.reviewID)
        reviewRef.setData([
            "user_id": review.userID,
            "evaluation": review.evaluation,
            "comment": review.comment,
            "image_number": review.imageCount,
            "created_at": timeStamp
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

protocol FirebaseHelperDelegate: class {
    func completedFetchingShop(shops: [Shop])
    func completedFetchingReviews(reviews: [Review])
    func completedFetchingPictures(pictures: [UIImage])
    func completedFetchingProfile(profile: Profile)
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
    func completedFetchingProfile(profile: Profile) {
        print("default implemented completedFetchingProfile")
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
    let createdDate: Date
    
    func displayDate() -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        return dateFormater.string(from: createdDate)
    }
}

struct Profile {
    var userName: String
    var icon: UIImage?
}
