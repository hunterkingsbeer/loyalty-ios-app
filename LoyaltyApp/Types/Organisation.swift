//
//  Organisation.swift
//  Loyalty
//
//  Created by Hunter Kingsbeer on 10/09/23.
//

import Foundation
import SwiftUI
import CachedAsyncImage

class Organization: ObservableObject, Identifiable {
    let id: UUID = UUID()
    let username: String
    let name: String
    let description: String
    let type: OrganizationType
    let address: String
    let color: Color
    let employees: [Employee]
    
    let logoUrl: URL?
    var logo: CachedAsyncImage<_ConditionalContent<_ConditionalContent<ProgressView<EmptyView, EmptyView>, Image>, some View>> {
        Image.fromAsync(url: logoUrl, color: color)
    }
    
    let coverUrl: URL?
    var cover: CachedAsyncImage<_ConditionalContent<_ConditionalContent<ProgressView<EmptyView, EmptyView>, Image>, some View>> {
        Image.fromAsync(url: coverUrl, color: color)
    }
    
    let imageUrls: [URL?]
    var images: [CachedAsyncImage<_ConditionalContent<_ConditionalContent<ProgressView<EmptyView, EmptyView>, Image>, some View>>] {
        imageUrls.map { Image.fromAsync(url: $0, color: color) }
    }
    
    init(username: String,
         name: String,
         type: OrganizationType,
         description: String,
         address: String,
         logo: String,
         cover: String,
         images: [String],
         color: String,
         employees: [Employee]) {
        self.username = username
        self.name = name
        self.type = type
        self.address = address
        self.description = description
        self.coverUrl = URL(string: cover)
        self.logoUrl = URL(string: logo)
        self.imageUrls = images.map { URL(string: $0) }
        self.color = Color(hex: color) ?? Color("accentAlt")
        self.employees = employees
    }
}

enum OrganizationBookingType: String {
    case Appointment = "Appointment"
    case Reservation = "Reservation"
    case None = "None"
    
    var allowsBooking: Bool {
        switch self {
        case .Appointment, .Reservation: return true
        default: return false
        }
    }
}

enum OrganizationType: String, CaseIterable {
    case Barber = "BARBER"
    case Salon = "SALON"
    case Health = "HEALTH"
    case Food = "FOOD"
    case Unknown = "UNKNOWN"

    var info: (name: String, color: Color, icon: Image, bookingType: OrganizationBookingType) {
        switch self {
        case .Barber:
            return ("Barber", Color("coreGrey"), Image(systemName: "mustache"), .Appointment)
        case .Health:
            return ("Health", Color("coreRed"), Image(systemName: "cross"), .Appointment)
        case .Salon:
            return ("Salon", Color("coreOrange"), Image(systemName: "scissors"), .Appointment)
         case .Food:
            return ("Food", Color("coreGreen"), Image(systemName: "takeoutbag.and.cup.and.straw"), .Reservation)
        default:
            return ("Unknown", Color("text"), Image(systemName: "questionmark"), .None)
        }
    }
}

class OrganizationMetadata {
    let name: String
    let username: String
    let type: OrganizationType
    let color: Color
    
    init(name: String, username: String, type: OrganizationType, color: String) {
        self.name = name
        self.username = username
        self.type = type
        self.color = Color(hex: color) ?? Color.black
    }
}

class Employee: ObservableObject, Identifiable {
    let id: UUID = UUID()
    let username: String
    let firstName: String
    let lastName: String
    let description: String
    let position: String
    let dateStarted: Date
    let organizationMetadata: OrganizationMetadata
    
    let profileUrl: URL?
    var profileImage: CachedAsyncImage<_ConditionalContent<_ConditionalContent<ProgressView<EmptyView, EmptyView>, Image>, some View>> {
        Image.fromAsync(url: profileUrl, color: organizationMetadata.color)
    }
    
    var dateStartedFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        
        return formatter.string(from: dateStarted)
    }
    
    init(username: String,
         firstName: String,
         lastName: String,
         description: String,
         position: String,
         profileUrl: String,
         dateStarted: Date,
         organizationMetadata: OrganizationMetadata) {
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.description = description
        self.position = position
        self.profileUrl = URL(string: profileUrl)
        self.dateStarted = dateStarted
        self.organizationMetadata = organizationMetadata
    }
}
