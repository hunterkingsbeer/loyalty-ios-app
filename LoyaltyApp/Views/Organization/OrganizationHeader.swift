//
//  BusinessHeader.swift
//  LoyaltyApp
//
//  Created by Hunter Kingsbeer on 25/09/23.
//

import SwiftUI

struct OrganizationHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OrganizationHeader(organization: OrgFreshPrinceBarbers, viewingAboutSection: .constant(true))
            OrganizationHeader(organization: OrgFreshPrinceBarbers, viewingAboutSection: .constant(false))
        }
        .environmentObject(StateService())
    }
}

struct OrganizationHeader: View {
    var organization: Organization
    @Binding var viewingAboutSection: Bool
    
    @EnvironmentObject var stateService: StateService
    @EnvironmentObject var organizationsService: OrganizationsService
    
    var isFavorite: Bool {
        return stateService.account!.loyalties.contains(organization.username)
    }
    
    var body: some View {
        ZStack {
            Color.white
                .offset(y: UIScreen.ScreenHeight * 0.1)
            
            VStack {
                VStack(alignment: .leading) {
                    CardView(org: organization)
                        .padding(.bottom)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(organization.type.info.name)
                                
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 2.5))
                                
                                Text("$$$")
                                
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 2.5))
                                
                                Text("1.2km away")
                                Image(systemName: "location.fill")
                                    .font(.footnote)
                                Spacer()
                            }
                            .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        Button(action: {
                            toggleFavorite()
                            generateHaptic(style: .light)
                        }){
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .foregroundColor(Color.black)
                                .font(.system(size: 22))
                                .padding(.trailing)
                        }
                        .buttonStyle(ShrinkingButton())
                    }
                    
                    Text(organization.description)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 1)
                }
                .padding()
                
                if organization.type.info.bookingType.allowsBooking {
                    SectionHeaderView(viewingAboutSection: $viewingAboutSection)
                } else {
                    Divider()
                        .frame(height: lineWidth)
                        .overlay(Color.black)
                }
            }
        }
    }
    
    func toggleFavorite() {
        if (isFavorite) {
            let updatedOrgs = stateService.account!.loyalties.filter{ $0 != organization.username }
            stateService.UpdateLoyalties(orgUsernames: updatedOrgs)
        } else {
            let updatedOrgs = stateService.account!.loyalties + [organization.username]
            stateService.UpdateLoyalties(orgUsernames: updatedOrgs)
        }
    }
}

struct SectionHeaderView: View {
    @Binding var viewingAboutSection: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewingAboutSection = true
                    generateHaptic(style: .light)
                }){
                    HStack {
//                        Text("About")
                        Image(systemName: "info.circle")
                    }
                    .frame(width: UIScreen.ScreenWidth * 0.5)
                    .contentShape(Rectangle())
                }.buttonStyle(ShrinkingButton())
                
                Button(action: {
                    viewingAboutSection = false
                    generateHaptic(style: .light)
                }){
                    HStack {
//                        Text("Appointments")
                        Image(systemName: "calendar")
                    }
                    .frame(width: UIScreen.ScreenWidth * 0.5)
                    .contentShape(Rectangle())
                }
                .buttonStyle(ShrinkingButton())
            }
            .frame(height: UIScreen.ScreenHeight * 0.02)
            .padding(.bottom, 5)
            
            HStack {
                if !viewingAboutSection {
                    Spacer()
                }
                
                VStack {
                    Divider()
                        .frame(width: UIScreen.ScreenWidth * 0.5,
                               height: lineWidth)
                        .overlay(Color.black)
                }
                
                if viewingAboutSection {
                    Spacer()
                }
            }
            .animation(.spring(), value: viewingAboutSection)
        }
    }
}
