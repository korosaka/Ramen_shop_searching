//
//  ProfileSettingViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-29.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import Photos
class ProfileViewModel: ObservableObject {
    @Published var userProfile: Profile
    @Published var isEditingName = false
    @Published var newName = Constants.EMPTY
    @Published var isShowPhotoLibrary = false
    @Published var isShowPhotoPermissionDenied = false
    @Published var isShowingProgress = false
    @Published var isShowingMenu = false
    @Published var userFavorites: [FavoriteShopInfo]
    var db: DatabaseHelper
    var authentication: Authentication
    var userID: String?
    @Published var isShowingAlert = false
    var activeAlertForName: ActiveAlert = .confirmation
    var isNameEdited: Bool { isEditingName && newName != Constants.EMPTY }
    var hasProfileAlready = false
    
    init() {
        db = .init()
        authentication = .init()
        userFavorites = .init()
        userProfile = Profile()
        db.delegate = self
        fetchData()
    }
    
    func checkCurrentUser() {
        guard let _userID = authentication.getUserUID() else { return }
        userID = _userID
        isShowingProgress = true
        db.fetchUserProfile(userID: _userID)
    }
    
    //MARK: TODO is it right to return SwiftUI View to View from VM???
    func getIconImage() -> Image {
        guard let iconImage = userProfile.icon else {
            return Image(systemName: "person.crop.circle.fill")
        }
        return Image(uiImage: iconImage)
    }
    
    func getUserName() -> String {
        return userProfile.userName
    }
    
    func updateUserName() {
        guard let _userID = userID else { return }
        isShowingProgress = true
        db.updateUserName(userID: _userID, name: newName, hasProfileAlready)
        newName = Constants.EMPTY
        isEditingName = false
    }
    
    func updateUserIcon(iconImage: UIImage) {
        guard let _userID = userID else { return }
        isShowingProgress = true
        db.updateUserIcon(_userID, iconImage, hasProfileAlready)
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
    
    func resetAlertData() {
        activeAlertForName = .confirmation
    }
    
    func onClickChangeName() {
        isEditingName.toggle()
        newName = Constants.EMPTY
    }
    
    func showUserFavorites() {
        guard let _userID = userID else { return }
        db.fetchUserFavorites(of: _userID)
    }
    
    func fetchFavoriteShopNames() {
        for shopInfo in userFavorites {
            db.fetchShop(shopID: shopInfo.id)
        }
    }
    
    func fetchData() {
        checkCurrentUser()
        showUserFavorites()
    }
    
    func reload() {
        userFavorites.removeAll()
        fetchData()
    }
}

extension ProfileViewModel: FirebaseHelperDelegate {
    func completedFetchingProfile(profile: Profile?) {
        isShowingProgress = false
        guard let _profile = profile else { return }
        userProfile = _profile
        hasProfileAlready = true
    }
    
    func completedUpdatingUserProfile(isSuccess: Bool) {
        if isSuccess {
            if !hasProfileAlready { hasProfileAlready = true }
            activeAlertForName = .completion
        } else {
            activeAlertForName = .error
        }
        isShowingAlert = true
        guard let _userID = userID else {
            isShowingProgress = false
            return
        }
        db.fetchUserProfile(userID: _userID)
    }
    
    func completedFetchingUserFavorites(favoriteIDs: [String]) {
        for favorite in favoriteIDs {
            let favoriteShop = FavoriteShopInfo(id: favorite,
                                                shopName: nil,
                                                shopTopImage: nil)
            userFavorites.append(favoriteShop)
        }
        for favorite in favoriteIDs {
            db.fetchShop(shopID: favorite)
        }
    }
    
    func completedFetchingShop(fetchedShopData: Shop) {
        for index in 0..<userFavorites.count {
            let shopInfo = userFavorites[index]
            if shopInfo.id == fetchedShopData.shopID {
                let newInfo = FavoriteShopInfo(id: shopInfo.id,
                                               shopName: fetchedShopData.name,
                                               shopTopImage: shopInfo.shopTopImage)
                userFavorites[index] = newInfo
            }
        }
        
        for favorite in userFavorites {
            db.fetchPictureReviews(shopID: favorite.id, limit: 1)
        }
    }
    
    func completedFetchingPictures(pictures: [UIImage], shopID: String?) {
        guard let _shopID = shopID else { return }
        if pictures.count == 0 { return }
        let image = Image(uiImage: pictures[0])
        
        for index in 0..<userFavorites.count {
            let shopInfo = userFavorites[index]
            if shopInfo.id == _shopID {
                let newInfo = FavoriteShopInfo(id: shopInfo.id,
                                               shopName: shopInfo.shopName,
                                               shopTopImage: image)
                userFavorites[index] = newInfo
            }
        }
    }
}

extension ProfileViewModel: ImagePickerDelegate {
    func pickedPicture(image: UIImage) {
        updateUserIcon(iconImage: image)
    }
}
