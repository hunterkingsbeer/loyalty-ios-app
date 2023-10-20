//
//  FakeData.swift
//  LoyaltyApp
//
//  Created by Hunter Kingsbeer on 25/09/23.
//

import Foundation
import SwiftUI

func getImages(org: String) -> [String] {
    return ["https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/\(org)/media/1.jpg",
            "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/\(org)/media/2.jpg",
            "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/\(org)/media/3.jpg",]
}

let defaultImageUrl = URL(string: "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/default.jpg")!

let DefaultAccount = Account(username: "loyalty@hunterkingsbeer.com",
                      email: "hi@hunterkingsbeer.com",
                      firstName: "Hunter",
                      lastName: "Kingsbeer",
                      birthday: Date.now,
                      loyalties: ["rascals_and_rogues", "fresh_prince_barbers", "pattis_and_cream"])

let OrgEmployee = Employee(username: "username",
                        firstName: "Nura",
                        lastName: "Baby",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Morbi tristique senectus et netus. Diam donec adipiscing tristique.",
                        position: "Top Tier",
                        profileUrl: "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/b9e3589d-3f15-432a-b2d0-9053b8ff02d4.png",
                        dateStarted: Date.now,
                        organizationMetadata: OrganizationMetadata(name: "Organization",
                                                                   username: "org_username",
                                                                   type: .Salon,
                                                                   color: "#cf3838"))
    

let OrgRascalsAndRogues =
    Organization(username: "rascals_and_rogues",
                 name: "Rascals and Rogues",
                 type: OrganizationType.Barber,
                 description: "Classic Barbering with a modern twist.",
                 address: "374 George St",
                 logo: "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/rascals_and_rogues/logo.jpg",
                 cover: "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/rascals_and_rogues/cover.jpg",
                 images: getImages(org: "rascals_and_rogues"),
                 color: "#d0d0d0",
                 employees: [OrgEmployee, OrgEmployee, OrgEmployee])

let OrgPattisAndCream =
    Organization(username: "pattis_and_cream",
                 name: "Pattis and Cream",
                 type: OrganizationType.Food,
                 description: "Icecream GETCHA ICESCREAM!!!.",
                 address: "381 George St",
                 logo: "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/pattis_and_cream/logo.jpg",
                 cover: "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/pattis_and_cream/cover.jpg",
                 images: getImages(org: "pattis_and_cream"),
                 color: "#cf3838",
                 employees: [OrgEmployee, OrgEmployee, OrgEmployee])

let OrgLoft =
    Organization(username: "loft",
                 name: "Loft",
                 type: OrganizationType.Salon,
                 description: "Contemporary hair trends with a warm friendly environment.",
                 address: "53 Crawford St",
                 logo: "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/loft/logo.jpg",
                 cover: "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/loft/cover.jpg",
                 images: getImages(org: "loft"),
                 color: "#000000",
                 employees: [OrgEmployee, OrgEmployee, OrgEmployee])

let OrgRoslynPharmacy =
    Organization(username: "roslyn_pharmacy",
                 name: "Roslyn Pharmacy",
                 type: OrganizationType.Health,
                 description: "Roslyn Pharmacy is a busy community pharmacy, located in the heart of Roslyn, Dunedin.",
                 address: "287A Highgate",
                 logo: "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/roslyn_pharmacy/logo.jpg",
                 cover: "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/roslyn_pharmacy/cover.jpg",
                 images: getImages(org: "roslyn_pharmacy"),
                 color: "#a3cc6e",
                 employees: [OrgEmployee, OrgEmployee, OrgEmployee])

let OrgFreshPrinceBarbers =
    Organization(username: "fresh_prince_barbers",
                 name: "Fresh Prince Barbers",
                 type: OrganizationType.Barber,
                 description: "OPEN MONDAY TO SUNDAY. 10AM TO 7PM.",
                 address: "290 Highgate",
                 logo: "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/fresh_prince_barbers/logo.jpg",
                 cover: "https://loyalty-app-organizations.s3.ap-southeast-2.amazonaws.com/fresh_prince_barbers/cover.jpg",
                 images: getImages(org: "fresh_prince_barbers"),
                 color: "#75ad55",
                 employees: [OrgEmployee, OrgEmployee, OrgEmployee])

let allOrgs = [ OrgRascalsAndRogues, OrgFreshPrinceBarbers, OrgPattisAndCream, OrgLoft, OrgRoslynPharmacy ]
