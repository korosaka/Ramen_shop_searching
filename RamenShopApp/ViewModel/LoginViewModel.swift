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
    
    func login() {
        authentication.login(email: email, password: password)
    }
    
    func createAccount() {
        authentication.createAccount(email: email, password: password)
    }
    
    init() {
        authentication = .init()
        authentication.delegate = self
    }
    
    func afterLogin() {
//        print("afterLogin")
        self.logined = true
    }
    
    func loginError() {}
    func afterLogout() {}
    
}
