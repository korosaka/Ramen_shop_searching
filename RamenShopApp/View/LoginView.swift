//
//  LoginView.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-11-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

struct SignupView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(additionalAction: nil)
            Spacer()
            TextField("email", text: $viewModel.email)
                .basicStyle()
            TextField("passsword", text: $viewModel.password)
                .basicStyle()
                .padding(.init(top: 0,
                               leading: 0,
                               bottom: 20,
                               trailing: 0))
            Button(action: {
                self.viewModel.createAccount()
            }) {
                Text("Create account")
                    .basicButtonTextStyle(Color.white, Color.yellow)
            }
            .alert(isPresented: $viewModel.signUpError) {
                Alert(title: Text("Signup Error"),
                      message: Text(viewModel.errorMesaage),
                      dismissButton: .default(Text("OK"),
                                              action: { self.viewModel.reset() }))
            }
            Spacer()
        }
        .background(Color.green)
        .navigationBarHidden(true)
    }
}


//MARK: TODO separate View
struct LoginView: View {
    
    @ObservedObject var loginVM: LoginViewModel
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.pink
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Ramen Search App")
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.init(top: 40,
                                       leading: 0,
                                       bottom: 40,
                                       trailing: 0))
                        .background(Color.red)
                        .cornerRadius(20)
                        .padding(.init(top: 100,
                                       leading: 5,
                                       bottom: 0,
                                       trailing: 5))
                        .navigationBarHidden(true)
                    if(loginVM.logined) {
                        Text("logined")
                            .font(.title)
                            .foregroundColor(Color.white)
                            .underline()
                            .padding()
                        
                        Button(action: {
                            self.loginVM.logout()
                        }) {
                            Text("Logout")
                                .basicButtonTextStyle(Color.white, Color.purple)
                                .padding(.init(top: 10,
                                               leading: 0,
                                               bottom: 0,
                                               trailing: 0))
                        }
                        .alert(isPresented: $loginVM.logoutError) {
                            Alert(title: Text("Logout Error"),
                                  message: Text(loginVM.errorMesaage),
                                  dismissButton: .default(Text("OK"),
                                                          action: { self.loginVM.reset() }))
                        }
                    } else {
                        VStack {
                            TextField("email", text: $loginVM.email)
                                .basicStyle()
                            TextField("passsword", text: $loginVM.password)
                                .basicStyle()
                                .padding(.init(top: 0,
                                               leading: 0,
                                               bottom: 20,
                                               trailing: 0))
                            Button(action: {
                                self.loginVM.login()
                            }) {
                                Text("Login")
                                    .basicButtonTextStyle(Color.white, Color.blue)
                            }
                            .alert(isPresented: $loginVM.loginError) {
                                Alert(title: Text("Login Error"),
                                      message: Text(loginVM.errorMesaage),
                                      dismissButton: .default(Text("OK"),
                                                              action: { self.loginVM.reset() }))
                            }
                        }
                        .padding(.init(top: 100,
                                       leading: 0,
                                       bottom: 0,
                                       trailing: 0))
                        .onAppear() { self.loginVM.reset() }
                    }
                    
                    Spacer()
                    if(loginVM.logined) {
                        NavigationLink(destination: MapTopView()) {
                            Text("Go to Ramen Search !").basicButtonTextStyle(Color.white, Color.red)
                        }
                        Spacer().frame(height: 30)
                        NavigationLink(destination: ProfileSettingView()
                                        .environmentObject(ProfileSettingViewModel())) {
                            Text("Profile").basicButtonTextStyle(Color.white, Color.orange)
                        }
                    }
                    Spacer()
                    
                    if(!loginVM.logined) {
                        NavigationLink(destination: SignupView(viewModel: loginVM)) {
                            Text("Create new account")
                                .basicButtonTextStyle(Color.white, Color.yellow)
                                .padding(.init(top: 0,
                                               leading: 0,
                                               bottom: 10,
                                               trailing: 0))
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            self.loginVM.reset()
                        })
                    }
                }
            }
        }
    }
}

