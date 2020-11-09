//
//  LoginView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    
    @ObservedObject var loginVM: LoginViewModel
    
    var body: some View {
        VStack {
            
            TextField("email", text: $loginVM.email)
            TextField("passsword", text: $loginVM.password)
            Button(action: {
                self.loginVM.createAccount()
            }) {
                Text("Create account")
            }
        }
    }
}

struct LoginView: View {
    
    @ObservedObject var loginVM: LoginViewModel
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello,\(loginVM.email)")
                Text("Ramen Search")
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .background(Color.red)
                TextField("email", text: $loginVM.email)
                TextField("passsword", text: $loginVM.password)
                Button(action: {
                    self.loginVM.login()
                }) {
                    Text("Login")
                }
                Spacer()
                if(loginVM.logined) {
                    NavigationLink(destination: MapSearchingView()) {
                        Text("Go to Ramen Search !")
                            .foregroundColor(Color.blue)
                    }
                }
                Spacer()
                NavigationLink(destination: SignupView(loginVM: loginVM)) {
                    Text("Create new account")
                        .foregroundColor(Color.blue)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginVM: .init())
    }
}


struct Signup_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(loginVM: .init())
    }
}
