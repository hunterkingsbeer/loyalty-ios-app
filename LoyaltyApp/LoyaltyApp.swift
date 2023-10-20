//
//  LoyaltyAppApp.swift
//  LoyaltyApp
//
//  Created by Hunter Kingsbeer on 21/09/23.
//

import SwiftUI

@main
struct LoyaltyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserSettings())
                .environmentObject(OrganizationsService())
                .environmentObject(StateService())
                .onAppear {
                    URLCache.shared.memoryCapacity = 10_000_000 // ~10 MB memory space
                    URLCache.shared.diskCapacity = 250_000_000 // ~250MB disk cache space}
                }
        }
    }
}
