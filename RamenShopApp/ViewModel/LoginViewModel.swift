//
//  LoginViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
class LoginViewModel: ObservableObject, AuthenticationDelegate {
    
    
    var authentication: Authentication
    
    @Published var email = ""
    @Published var password = ""
    @Published var logined = false
    
    @Published var loginError = false
    @Published var signUpError = false
    @Published var logoutError = false
    var errorMesaage = ""
    
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
        loginError = false
        signUpError = false
        logoutError = false
        errorMesaage = ""
    }
    
    init() {
        authentication = .init()
        authentication.delegate = self
    }
    
    func afterLogin() {
        self.logined = true
    }
    
    func loginError(error: Error?) {
        if error != nil {
            loginError = true
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
    
}
