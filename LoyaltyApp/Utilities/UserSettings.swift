//
//  UserSettings.swift
//  Loyalty
//
//  Created by Hunter Kingsbeer on 10/09/23.
//

import Foundation
import SwiftUI
import Combine

// Class of settings that the user may specify, impacting the interface.
class UserSettings: ObservableObject {
    @Published var darkMode: Bool {
        didSet { UserDefaults.standard.set(darkMode, forKey: "darkMode") }
    }

    init() {
        self.darkMode = UserDefaults.standard.object(forKey: "darkMode") as? Bool ?? false
    }
}

