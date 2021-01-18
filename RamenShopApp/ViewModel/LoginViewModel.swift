//
//  LoginViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import Firebase

// MARK: TODO separate extention AuthenticationDelegate
class LoginViewModel: ObservableObject {
    var authentication: Authentication
    var db: FirebaseHelper
    
    @Published var email = ""
    @Published var password = ""
    @Published var logined = false
    @Published var isShowLoginAlert = false
    @Published var signUpError = false
    @Published var logoutError = false
    var isEmailNotVerified = false
    var errorMesaage = ""
    var isAdmin: Bool {
        return email == "ramen.shop.admin@gmail.com"
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
        authentication.login(email: email, password: password)
    }
    
    func createAccount() {
        authentication.createAccount(email: email, password: password)
    }
    
    func logout() {
        authentication.logout()
    }
    
    func reset() {
        email = ""
        password = ""
        isShowLoginAlert = false
        signUpError = false
        logoutError = false
        errorMesaage = ""
        isEmailNotVerified = false
    }
}

extension LoginViewModel: AuthenticationDelegate {
    
    func afterLogin() {
        self.logined = true
        guard let _userID = authentication.getUserUID() else { return }
        RegisteringToken().registerTokenToUser(to: _userID)
    }
    
    func afterSignUp(userID: String) {
        db.uploadUserProfile(userID)
    }
    
    func loginError(error: Error?) {
        if error != nil {
            isShowLoginAlert = true
            errorMesaage = "error: \(error!)"
        }
    }
    
    func signUpError(error: Error?) {
        if error != nil {
            self.signUpError = true
            errorMesaage = "error: \(error!)"
        }
    }
    
    func logoutError(error: NSError?) {
        if error != nil {
            self.logoutError = true
            errorMesaage = "error: \(error!)"
        }
    }
    
    func afterLogout() {
        self.logined = false
    }
    
    func informEmailNotVerified() {
        isEmailNotVerified = true
        isShowLoginAlert = true
    }
}

extension LoginViewModel: FirebaseHelperDelegate {
    func completedUpdatingUserProfile(isSuccess: Bool) {
        if isSuccess {
            self.logined = true
            
            //MARK: TODO it seems unneeded
            checkCurrentUser()
            
            guard let _userID = authentication.getUserUID() else { return }
            RegisteringToken().registerTokenToUser(to: _userID)
        } else {
            self.signUpError = true
            errorMesaage = "signup error"
        }
    }
}
