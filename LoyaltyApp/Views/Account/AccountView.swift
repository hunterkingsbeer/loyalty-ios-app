//
//  AccountView.swift
//  LoyaltyApp
//
//  Created by Hunter Kingsbeer on 7/10/23.
//

import SwiftUI
import Auth0
import CodeScanner

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(StateService())
    }
}

struct AccountView: View {
    @EnvironmentObject var stateService: StateService
    
    @State var showScanner: Bool = false
    private func toggleScanner() { showScanner.toggle() }
    
    var account: Account? {
        return stateService.account
    }
    
    var body: some View {
        ZStack {
            if account != nil {
                VStack(spacing: 0) {
                    TopHeadingView(text: "Account")
                    
                    VStack {
                        CardAccountView(account: stateService.account!)
                        
                        VStack {
                            AccountViewButton(text: "Scan QR Code",
                                              icon: "qrcode.viewfinder",
                                              function: toggleScanner)
                            .sheet(isPresented: $showScanner){
                                ScannerView()
                            }
                            
                            AccountViewButton(text: "Logout",
                                              icon: "lock.fill",
                                              iconColor: Color("red"),
                                              function: stateService.logout)
                        }
                        .padding(.vertical)
                        
                        Spacer()
                    }
                    .padding()
                }
            } else {
                ProgressView()
            }
        }
    }
}

struct AccountViewButton: View {
    let text: String
    var textColor: Color = Color.black
    
    let icon: String
    var iconColor: Color = Color.black
    
    var borderColor: Color = Color.black
    
    var function: () -> Void
    
    var body: some View {
        Button(action: function){
            VStack {
                HStack {
                    Text(text)
                        .foregroundColor(textColor)
                    
                    Spacer()
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(borderColor, lineWidth: lineWidth)
            )
        }
        .buttonStyle(ShrinkingButton())
    }
}

struct ScannerView: View {
    @EnvironmentObject var stateService: StateService

    @State var account: Account? = nil
    @State var showingResult: Bool = false

    var body: some View {
        ZStack {
            if showingResult {
                Color.black
            } else {
                CodeScannerView(codeTypes: [.qr], showViewfinder: true, simulatedData: "rascals_and_rogues") { response in
                    if case let .success(result) = response {
                        let username = result.string
                        account = stateService.GetAccount(username: username)
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .onChange(of: account != nil, perform: { _ in
            showingResult = self.account != nil ? true : false
        })
        .sheet(isPresented: $showingResult){
            if let account = self.account {
                CardAccountView(account: account)
            } else {
                ProgressView()
            }
        }
    }
}
