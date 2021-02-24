//
//  LoginViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    var authentication: Authentication
    var db: DatabaseHelper
    
    @Published var email = Constants.EMPTY
    @Published var password = Constants.EMPTY
    @Published var logined = false
    @Published var isShowLoginAlert = false
    @Published var isShowSignUpAlert = false
    @Published var logoutError = false
    @Published var isShowingProgress = false
    var isEmailNotVerified = false
    var sentEmail = false
    var errorMesaage = Constants.EMPTY
    var isAdmin: Bool {
        return email == Constants.ADMIN_EMAIL
    }
    
    init() {
        authentication = .init()
        db = .init()
        authentication.delegate = self
        db.delegate = self
        checkCurrentUser()
    }
    
    func checkCurrentUser() {
        if !authentication.isEmailVerified { return }
        self.logined = true
        guard let userEmail = authentication.getUserEmail() else { return }
        self.email = userEmail
    }
    
    func login() {
        isShowingProgress = true
        authentication.login(email: email, password: password)
    }
    
    func createAccount() {
        isShowingProgress = true
        authentication.createAccount(email: email, password: password)
    }
    
    func logout() {
        isShowingProgress = true
        authentication.logout()
    }
    
    func reset() {
        email = Constants.EMPTY
        password = Constants.EMPTY
        isShowLoginAlert = false
        isShowSignUpAlert = false
        logoutError = false
        errorMesaage = Constants.EMPTY
        isEmailNotVerified = false
        sentEmail = false
    }
}

extension LoginViewModel: AuthenticationDelegate {
    
    func afterLogin() {
        isShowingProgress = false
        self.logined = true
        guard let _userID = authentication.getUserUID() else { return }
        RegisteringToken().registerTokenToUser(to: _userID)
    }
    
    func loginError(error: Error?) {
        isShowingProgress = false
        if error != nil {
            isShowLoginAlert = true
            errorMesaage = "error: \(error!)"
        }
    }
    
    func signUpError(error: Error?) {
        isShowingProgress = false
        if error != nil {
            self.isShowSignUpAlert = true
            errorMesaage = "error: \(error!)"
        }
    }
    
    func logoutError(error: NSError?) {
        isShowingProgress = false
        if error != nil {
            self.logoutError = true
            errorMesaage = "error: \(error!)"
        }
    }
    
    func afterLogout() {
        self.isShowingProgress = false
        self.logined = false
    }
    
    func informEmailNotVerified() {
        isEmailNotVerified = true
        isShowLoginAlert = true
    }
    
    func completedSendingEmail(isSuccess: Bool) {
        if isSuccess {
            isShowingProgress = false
            sentEmail = true
            isShowSignUpAlert = true
            db.uploadUserProfile(authentication.getUserUID()!)
        } else {
            authentication.deleteAccount()
        }
    }
    
    func completedDeletingAccount(isSuccess: Bool) {
        isShowingProgress = false
        if isSuccess {
            self.isShowSignUpAlert = true
            errorMesaage = "Your Email adress may be invalid. Please use valid Email adress."
        }
    }
}

extension LoginViewModel: FirebaseHelperDelegate {
    func completedUpdatingUserProfile(isSuccess: Bool) {
        if !isSuccess { return }
        guard let _userID = authentication.getUserUID() else { return }
        RegisteringToken().registerTokenToUser(to: _userID)
    }
}
