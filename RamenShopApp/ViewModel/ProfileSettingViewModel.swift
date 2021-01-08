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
class ProfileSettingViewModel: ObservableObject {
    @Published var userProfile: Profile
    @Published var isEditingName = false
    @Published var newName = ""
    @Published var isShowPhotoLibrary = false
    @Published var isShowPhotoPermissionDenied = false
    var db: FirebaseHelper
    var authentication: Authentication
    var userID: String?
    @Published var isShowAlertForName = false
    var activeAlertForName: ActiveAlert = .confirmation
    var isNameEdited: Bool { isEditingName && newName != "" }
    var hasProfileAlready = false
    var changeNameButtonText: String {
        if isEditingName {
            return "cancel"
        } else {
            return "change name"
        }
    }
    
    init() {
        db = .init()
        authentication = .init()
        //MARK: TODO refactoring (profile init)
        userProfile = Profile(userName: "unnamed")
        db.delegate = self
        checkCurrentUser()
    }
    
    func checkCurrentUser() {
        guard let _userID = authentication.getUserUID() else { return }
        userID = _userID
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
        db.updateUserName(userID: _userID, name: newName, hasProfileAlready)
        newName = ""
        isEditingName = false
    }
    
    func updateUserIcon(iconImage: UIImage) {
        guard let _userID = userID else { return }
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
        newName = ""
    }
}

extension ProfileSettingViewModel: FirebaseHelperDelegate {
    func completedFetchingProfile(profile: Profile?) {
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
        isShowAlertForName = true
        guard let _userID = userID else { return }
        db.fetchUserProfile(userID: _userID)
    }
}

extension ProfileSettingViewModel: ImagePickerDelegate {
    func pickedPicture(image: UIImage) {
        updateUserIcon(iconImage: image)
    }
}
