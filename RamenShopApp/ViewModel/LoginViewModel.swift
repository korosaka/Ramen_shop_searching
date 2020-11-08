//
//  LoginViewModel.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
class LoginViewModel: ObservableObject {
    
    @Published var userName = ""
    @Published var password = ""
    
    func login() {
        print("login (user: \(userName), pass: \(password))")
    }
}
