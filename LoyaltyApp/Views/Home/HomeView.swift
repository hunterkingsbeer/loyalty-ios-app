//
//  HomeView.swift
//  Loyalty
//
//  Created by Hunter Kingsbeer on 18/09/23.
//

import SwiftUI
import CachedAsyncImage

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(OrganizationsService())
            .environmentObject(StateService())
    }
}

struct HomeView: View {
    @EnvironmentObject var organizationsService: OrganizationsService
    @EnvironmentObject var stateService: StateService
    
    var account: Account? {
        return stateService.account
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                        Section {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Welcome \(stateService.account?.firstName.capitalizingFirstLetter() ?? "")!")
                                    .font(.system(.title, weight: .semibold))
                                
                                AppointmentCardView(organization: OrgRascalsAndRogues,
                                                    appointmentActivity: "Beard trim",
                                                    subtitle: "2pm Wednesday, 19th August.")
                                
                                AppointmentCardView(organization: OrgPattisAndCream,
                                                    appointmentActivity: "Dinner",
                                                    subtitle: "6:30pm Friday, 21st August.")
                            }
                            .padding()
                        } header: {
                            TopHeadingView(text: "Home")
                        }
                        
                        Section {
                            VStack {
                                if organizationsService.organizations.isEmpty || account == nil {
                                    ProgressView()
                                    HStack {
                                        Spacer()
                                    }
                                } else {
                                    let orgs = organizationsService.organizations.filter{ account!.loyalties.contains($0.username) }
                                    
                                    if orgs.isEmpty {
                                        CardDefaultView()
                                            .padding(.top)
                                    } else {
                                        ForEach(orgs) { org in
                                            CardView(org: org, enableSheet: true)
                                                .padding(.bottom, 10)
                                        }
                                    }
                                }
                            }
                            .padding()
                        } header: {
                            sectionHeader(text: "Loyalties")
                        }
                    }
                }
                
                GeometryReader { reader in
                    Color.white
                        .frame(height: reader.safeAreaInsets.top, alignment: .top)
                        .ignoresSafeArea()
                }
            }
        }
    }
    
    func sectionHeader(text: String) -> some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                Color.white
                    .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: lineWidth)
                    .overlay(Color("accentAlt"))
            }
            
            Text(text)
                .font(.system(.largeTitle, weight: .semibold))
                .padding(.horizontal)
                .padding(.vertical, 10)
        }
    }
}

struct AppointmentCardView: View {
    let organization: Organization
    let appointmentActivity: String
    let subtitle: String
    
    let logoSize: CGFloat = UIScreen.ScreenHeight * 0.05
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(appointmentActivity)
                        .font(.system(.body, weight: .semibold))
                    
                    Image(systemName: "arrow.right")
                        .font(.footnote)
                    
                    Text("\(organization.name)")
                }
                
                Text(subtitle)
            }
            
            Spacer()
            
            organization.logo
                .scaledToFit()
                .frame(width: logoSize, height: logoSize)
                .clipped()
                .background(.white)
                .cornerRadius(3)
        }
        .padding(.trailing)
        .background(
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 4)
                    .foregroundColor(organization.color)
                
            }
        )
    }
}
