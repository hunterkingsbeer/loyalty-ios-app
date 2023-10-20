//
//  ContentView.swift
//  Loyalty
//
//  Created by Hunter Kingsbeer on 9/09/23.
//

import SwiftUI
import CoreData
import CachedAsyncImage
import Auth0

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
            .environmentObject(OrganizationsService())
            .environmentObject(StateService())
            .onAppear {
                // ~10 MB memory space
                URLCache.shared.memoryCapacity = 10_000_000
                // ~250MB disk cache space}
                URLCache.shared.diskCapacity = 250_000_000
            }
    }
}

struct ContentView: View {
    @EnvironmentObject var stateService: StateService
    
    var body: some View {
        ZStack {
            if stateService.loginSuccess {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    DiscoverView()
                        .tabItem {
                            Label("Discover", systemImage: "magnifyingglass")
                        }
                    
                    AccountView()
                        .tabItem {
                            Label("Account", systemImage: "person")
                        }
                }
            } else {
                AuthenticationView()
            }
        }
        .animation(.spring(), value: stateService.loginSuccess)
        .accentColor(Color("text"))
        .toolbarBackground(Color("text"), for: .tabBar)
        .preferredColorScheme(.light)
    }
}

struct LoadingSplashView: View {
    var body: some View {
        VStack {
            Image("icon")
                .resizable()
                .frame(width: UIScreen.ScreenWidth * 0.35, height: UIScreen.ScreenWidth * 0.35)
            
            ProgressView()
                .padding()
                .padding(.top)
        }
    }
}


struct TopHeadingView: View {
    let text: String
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.white
                
                Divider()
                    .frame(height: lineWidth)
                    .overlay(Color("accentAlt"))
            }
            
            Text(text)
                .padding(10)
        }.fixedSize(horizontal: false, vertical: true)
    }
}
