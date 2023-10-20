//
//  Account.swift
//  LoyaltyApp
//
//  Created by Hunter Kingsbeer on 26/09/23.
//

import Foundation
import CachedAsyncImage
import SwiftUI

class Account: ObservableObject, Identifiable {
    let id: UUID = UUID()
    let username: String
    let email: String
    
    let firstName: String
    let lastName: String
    let birthday: Date
    
    let loyalties: [String]
    
    let profileUrl: URL?
    var profileImage: CachedAsyncImage<_ConditionalContent<_ConditionalContent<ProgressView<EmptyView, EmptyView>, Image>, Image>> {
        Image.fromAsync(url: profileUrl)
    }
    
    init(username: String,
         email: String,
         
         firstName: String,
         lastName: String,
         birthday: Date,
         
         loyalties: [String]) {
        self.username = username
        self.email = email
        
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        
        self.loyalties = loyalties
        self.profileUrl = defaultImageUrl
    }
}
