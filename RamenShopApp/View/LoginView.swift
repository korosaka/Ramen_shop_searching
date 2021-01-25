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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
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
                .alert(isPresented: $viewModel.isShowSignUpAlert) {
                    if viewModel.sentEmail {
                        return Alert(title: Text("Sent Email!"),
                                     message: Text("We sent Email to your adress, so please check it."),
                                     dismissButton: .default(Text("OK"),
                                                             action: {
                                                                self.viewModel.reset()
                                                                presentationMode.wrappedValue.dismiss()
                                                             }
                                     )
                        )
                    } else {
                        return Alert(title: Text("Signup Error"),
                                     message: Text(viewModel.errorMesaage),
                                     dismissButton: .default(Text("OK"),
                                                             action: { self.viewModel.reset() }))
                    }
                    
                }
                Spacer()
            }
            if viewModel.isShowingProgress {
                CustomedProgress()
            }
        }
        .background(Color.green)
        .navigationBarHidden(true)
    }
}


//MARK: TODO separate View
struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    
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
                    if(viewModel.logined) {
                        Text("logined")
                            .font(.title)
                            .foregroundColor(Color.white)
                            .underline()
                            .padding()
                        
                        Button(action: {
                            self.viewModel.logout()
                        }) {
                            Text("Logout")
                                .basicButtonTextStyle(Color.white, Color.purple)
                                .padding(.init(top: 10,
                                               leading: 0,
                                               bottom: 0,
                                               trailing: 0))
                        }
                        .alert(isPresented: $viewModel.logoutError) {
                            Alert(title: Text("Logout Error"),
                                  message: Text(viewModel.errorMesaage),
                                  dismissButton: .default(Text("OK"),
                                                          action: { self.viewModel.reset() }))
                        }
                    } else {
                        VStack {
                            TextField("email", text: $viewModel.email)
                                .basicStyle()
                            TextField("passsword", text: $viewModel.password)
                                .basicStyle()
                                .padding(.init(top: 0,
                                               leading: 0,
                                               bottom: 20,
                                               trailing: 0))
                            Button(action: {
                                self.viewModel.login()
                            }) {
                                Text("Login")
                                    .basicButtonTextStyle(Color.white, Color.blue)
                            }
                            .alert(isPresented: $viewModel.isShowLoginAlert) {
                                if viewModel.isEmailNotVerified {
                                    return Alert(title: Text("Your Email has not been verified."),
                                                 message: Text("We have sent a Email, so please check it."),
                                                 dismissButton: .default(Text("OK"),
                                                                         action: { self.viewModel.reset()
                                                                         }
                                                 )
                                    )
                                } else {
                                    return Alert(title: Text("Login Error"),
                                                 message: Text(viewModel.errorMesaage),
                                                 dismissButton: .default(Text("OK"),
                                                                         action: { self.viewModel.reset()
                                                                         }
                                                 )
                                    )
                                }
                            }
                        }
                        .padding(.init(top: 100,
                                       leading: 0,
                                       bottom: 0,
                                       trailing: 0))
                        .onAppear() { self.viewModel.reset() }
                    }
                    
                    Spacer()
                    if(viewModel.logined) {
                        if viewModel.isAdmin {
                            NavigationLink(destination: AdminPageView(viewModel: .init())) {
                                Text("Admin Page").basicButtonTextStyle(Color.white, Color.red)
                            }
                        } else {
                            NavigationLink(destination: MapTopView()) {
                                Text("Go to Ramen Search !").basicButtonTextStyle(Color.white, Color.red)
                            }
                        }
                    }
                    Spacer()
                    
                    if(!viewModel.logined) {
                        NavigationLink(destination: SignupView(viewModel: viewModel)) {
                            Text("Create new account")
                                .basicButtonTextStyle(Color.white, Color.yellow)
                                .padding(.init(top: 0,
                                               leading: 0,
                                               bottom: 10,
                                               trailing: 0))
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            self.viewModel.reset()
                        })
                    }
                }
                if viewModel.isShowingProgress {
                    CustomedProgress()
                }
            }
        }
    }
}

struct CustomedProgress: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView("in process")
                .foregroundColor(.white)
                .upDownPadding(size: 30)
            Spacer()
        }
        .background(Color.blue).cornerRadius(20)
        .sidePadding(size: 30)
    }
}
