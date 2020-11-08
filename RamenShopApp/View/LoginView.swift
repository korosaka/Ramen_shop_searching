//
//  LoginView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var loginVM: LoginViewModel
    
    
    var body: some View {
        VStack {
            Text("Hello, \(loginVM.userName)")
            Text("Ramen Search")
                .foregroundColor(Color.white)
                .font(.largeTitle)
                .background(Color.red)
            TextField("User name", text: $loginVM.userName)
            TextField("passsword", text: $loginVM.password)
            Button(action: {
                self.loginVM.login()
            }) {
                Text("Login")
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginVM: .init())
    }
}
