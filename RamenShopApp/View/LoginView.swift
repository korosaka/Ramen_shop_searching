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
            BackGroundView()
            VStack(spacing: 0) {
                CustomNavigationBar(additionalAction: nil)
                Spacer().frame(height: UIScreen.main.bounds.height / 5)
                Text("Sign Up")
                    .foregroundColor(.viridianGreen)
                    .font(.largeTitle)
                    .bold()
                    .shadow(color: .black, radius: 2, x: 2, y: 2)
                Spacer().frame(height: 70)
                TextField("email", text: $viewModel.email)
                    .basicStyle()
                Spacer().frame(height: 30)
                TextField("passsword", text: $viewModel.password)
                    .basicStyle()
                Spacer().frame(height: 50)
                Button(action: {
                    self.viewModel.createAccount()
                }) {
                    Text("sign up")
                        .containingSymbol(symbol: "person.badge.plus",
                                          color: .viridianGreen,
                                          textFont: .title,
                                          symbolFont: .title3)
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
        .navigationBarHidden(true)
    }
}


//MARK: TODO separate View
struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                BackGroundView()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer().frame(height: UIScreen.main.bounds.height / 4)
                    Text("RAMEN SHOP MAP").largestTitleStyle()
                    Spacer().frame(height: 70)
                    if(viewModel.logined) {
                        if viewModel.isAdmin {
                            NavigationLink(destination: AdminPageView(viewModel: .init())) {
                                Text("admin")
                                    .containingSymbol(symbol: "person.3",
                                                      color: .purple,
                                                      textFont: .title,
                                                      symbolFont: .title3)
                            }
                        } else {
                            NavigationLink(destination: MapTopView()) {
                                Text("start")
                                    .containingSymbol(symbol: "play.circle.fill",
                                                      color: .strongPink,
                                                      textFont: .title,
                                                      symbolFont: .title3)
                            }
                        }
                        Spacer().frame(height: 45)
                        Button(action: {
                            self.viewModel.logout()
                        }) {
                            Text("logout")
                                .foregroundColor(.darkGray)
                                .underline()
                                .font(.title2)
                        }
                        .alert(isPresented: $viewModel.logoutError) {
                            Alert(title: Text("Logout Error"),
                                  message: Text(viewModel.errorMesaage),
                                  dismissButton: .default(Text("OK"),
                                                          action: { self.viewModel.reset() }))
                        }
                        Spacer()
                    } else {
                        VStack {
                            TextField("email", text: $viewModel.email)
                                .basicStyle()
                            Spacer().frame(height: 30)
                            TextField("passsword", text: $viewModel.password)
                                .basicStyle()
                            Spacer().frame(height: 40)
                            Button(action: {
                                self.viewModel.login()
                            }) {
                                Text("login")
                                    .containingSymbol(symbol: "key.fill",
                                                      color: .seaBlue,
                                                      textFont: .title,
                                                      symbolFont: .title3)
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
                        .onAppear() { self.viewModel.reset() }
                        Spacer()
                        NavigationLink(destination: SignupView(viewModel: viewModel)) {
                            Text("sign up")
                                .containingSymbolWide(symbol: "chevron.right",
                                                      color: .viridianGreen,
                                                      textFont: .title,
                                                      symbolFont: .title3)
                                .sidePadding(size: 20)
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            self.viewModel.reset()
                        })
                        Spacer().frame(height: 20)
                    }
                }
                if viewModel.isShowingProgress {
                    CustomedProgress()
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CustomedProgress: View {
    var body: some View {
        ProgressView("in process")
            .foregroundColor(.viridianGreen)
            .upDownPadding(size: 15)
            .wideStyle()
            .background(Color.superWhitePasteGreen)
            .cornerRadius(20)
            .sidePadding(size: 30)
    }
}

struct BackGroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.green,
                                                   Color.pastelGreen]),
                       startPoint: .top,
                       endPoint: .bottom)
    }
}
