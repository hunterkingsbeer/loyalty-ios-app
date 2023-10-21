//
//  LoginView.swift
//  LoyaltyApp
//
//  Created by Hunter Kingsbeer on 13/10/23.
//

import SwiftUI

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(StateService())
    }
}

struct AuthenticationView: View {
    @EnvironmentObject var stateService: StateService
    @State var user: User?
    
    var body: some View {
        ZStack {
            if stateService.state == .AccountNotFound {
                VStack {
                    HStack {
                        Button(action: {
                            user = nil
                            stateService.logout()
                            generateHaptic(style: .light)
                        }){
                            HStack {
                                Image(systemName: "arrow.left")
                                Text("back to login")
                                    .padding(.leading, 5)
                            }
                            .underline()
                            .padding()
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(ShrinkingButton())
                        
                        Spacer()
                    }
                    Spacer()
                }
            }
            
            VStack {
                VStack {
                    Spacer()
                    
                    Image("Logo")
                        .resizable()
                        .frame(width: UIScreen.ScreenWidth * 0.35,
                               height: UIScreen.ScreenWidth * 0.35)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }
                
                switch stateService.state {
                
                case .AuthFail: LoginView()
                    
                case .AccountNotFound: SetupAccountView().frame(height: UIScreen.ScreenHeight * 0.6)
                
                case .Error: LoginResultView(text: "Please try again later", icon: "bolt.fill", color: Color("red"))
                
                case .Success: LoginResultView(text: "", icon: "checkmark", color: Color("green"))
                
                default: LoadingView()
                }
            }
        }
        .onAppear { stateService.authenticate(state: stateService.state) }
        .onChange(of: stateService.state, perform: { loginState in
            stateService.authenticate(state: loginState)
        })
    }
    
    func LoginResultView(text: String, icon: String, color: Color) -> some View {
        VStack {
            HStack {
                Text(text)
                    .fontWeight(.semibold)
                    
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            .padding(50)
            
            Spacer()
        }
    }
    
    func LoadingView() -> some View {
        VStack {
            ProgressView()
                .padding(50)
            Spacer()
        }
    }
}

struct LoginView: View {
    @EnvironmentObject var stateService: StateService
    
    var cornerRadius: CGFloat = 6
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Welcome to")
            Text("Loyalty")
                .font(.system(.largeTitle, weight: .semibold))
            
            Spacer()
            Text("Sign up or login to continue.")
            
            Button(action: {
                stateService.login()
                generateHaptic(style: .light)
            }){
                ZStack {
                    Color.white
                    
                    HStack {
                        Text("Authentication")
                            .font(.system(.title, weight: .medium))
                        
                        Spacer()
                        Image(systemName: "person.crop.circle")
                            .font(.title)
                    }
                    .padding().padding(.vertical)
                }
                .cornerRadius(cornerRadius)
                .containerShape(RoundedRectangle(cornerRadius: cornerRadius))
                .shadow(color: Color("coreGrey").opacity(0.2), radius: 3)
                .padding()
            }
            .buttonStyle(ShrinkingButton())
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct SetupAccountView: View {
    @EnvironmentObject var stateService: StateService
    
    @State var email: String = ""
    @State var first: String = ""
    @State var last: String = ""
    
    let cornerRadius: CGFloat = 6
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Finish setting up your account")
                .font(.system(.title, weight: .semibold))
                .lineLimit(3)
//                .padding(.bottom)
            
            Text("Your name & email")
                .padding(.top)
            HStack {
                TextField("First name", text: $first)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color("text"), lineWidth: lineWidth)
                            .shadow(color: Color("coreGrey").opacity(0.2), radius: 3)
                    )
                    .overlay(
                        HStack {
                            Spacer()
                            if !first.isEmpty {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color("green"))
                                    .font(.system(.caption, weight: .bold))
                            }
                        }.padding()
                    )
                
                TextField("Last name", text: $last)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color("text"), lineWidth: lineWidth)
                            .shadow(color: Color("coreGrey").opacity(0.2), radius: 3)
                    )
                    .overlay(
                        HStack {
                            Spacer()
                            if !last.isEmpty {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color("green"))
                                    .font(.system(.caption, weight: .bold))
                            }
                        }.padding()
                    )
            }
            
            TextField("Email", text: $email)
                .disabled(!stateService.username.isEmpty)
                .foregroundColor(stateService.username.isEmpty ? Color.black : Color.gray)
                .onAppear { self.email = stateService.username }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color("text"), lineWidth: lineWidth)
                        .shadow(color: Color("coreGrey").opacity(0.2), radius: 3)
                )
                .overlay(
                    HStack {
                        Spacer()
                        if !stateService.username.isEmpty {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color.black)
                                .font(.system(.caption, weight: .bold))
                        }
                        
                        if !email.isEmpty {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color("green"))
                                .font(.system(.caption, weight: .bold))
                        }
                    }.padding()
                )
                    
                
            
            Spacer()
            
            Button(action: {
                stateService.CreateAccount(email: email,
                                           first: first,
                                           last: last)
                generateHaptic(style: .light)
            }){
                HStack {
                    Text("Create account")
                        .font(.system(.title, weight: .medium))
                    
                    Spacer()
                    Image(systemName: "person.crop.circle")
                        .font(.title)
                }
                .padding().padding(.vertical)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color("text"), lineWidth: lineWidth)
                )
            }
            .buttonStyle(ShrinkingButton())
            .padding(.top, 20)
        }.padding()
    }
}
