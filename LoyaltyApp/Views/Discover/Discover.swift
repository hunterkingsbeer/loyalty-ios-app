//
//  Discover.swift
//  Loyalty
//
//  Created by Hunter Kingsbeer on 15/09/23.
//

import SwiftUI
import CachedAsyncImage

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
            .environmentObject(UserSettings())
            .environmentObject(OrganizationsService())
    }
}

struct DiscoverView: View {
    @State var search: String = ""
    
    @EnvironmentObject var organizationsService: OrganizationsService
    @EnvironmentObject var stateService: StateService
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                    
                    Section {
                        DiscoverHeaderView()
                    } header: {
                        TopHeadingView(text: "Discover")
                    }
                    
                    Section {
                        if search.isEmpty {
                            VStack {
                                DiscoverSectionView(organisations: organizationsService.ofType(orgType: .Barber),
                                                    type: OrganizationType.Barber)
                                
                                DiscoverSectionView(organisations: organizationsService.ofType(orgType: .Food),
                                                    type: OrganizationType.Food)
                                
                                DiscoverSectionView(organisations: organizationsService.ofType(orgType: .Salon),
                                                    type: OrganizationType.Salon)
                            }.padding(.vertical)
                        } else {
                            VStack {
                                ForEach(organizationsService.organizations.filter { $0.name.lowercased().contains(search.lowercased())}) { org in
                                    BusinessCardWideView(org: org)
                                }
                            }
                            .padding()
                        }
                    } header: {
                        SearchBar(search: $search)
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


struct DiscoverHeaderView: View {
    @EnvironmentObject var settings : UserSettings
    
    @State var activeTags: [String] = []
    @State var updatingLocation: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Places near you")
                .font(.system(.largeTitle, weight: .semibold))

            .padding(.bottom, 5)
            
            Button(action: {
                updatingLocation.toggle()
                generateHaptic(style: .light)
            }){
                HStack {
                    Text("Dunedin, New Zealand")
                    
                    Image(systemName: "location.fill")
                        .font(.footnote)
                        .padding(.trailing, 18)
                }
            }
            .buttonStyle(ShrinkingButton())
            .sheet(isPresented: $updatingLocation){
                VStack {
                    Text("Update your location")
                    
                    Image(systemName: "map")
                }
                .font(.system(.largeTitle, weight: .semibold))
            }
        }
        .padding()
        .animation(.spring(), value: activeTags.count)
    }
}

struct DiscoverSectionView: View {
    var organisations: [Organization]
    var type: OrganizationType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(type.info.name)
                    .font(.system(.title, weight: .semibold))

                Spacer()
                type.info.icon
                    .font(.system(.body, weight: .semibold))
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(organisations) { org in
                        BusinessCardView(org: org)
                    }
                }.padding(.horizontal)
            }
        }
    }
}


struct BusinessCardView: View {
    @State var active: Bool = false
    let org: Organization
    
    let cornerRadius: CGFloat = 12
    let height: CGFloat = UIScreen.ScreenHeight * 0.2
    var width: CGFloat { return height * 1.5 }
    var iconHeight: CGFloat { return height * 0.3 }
    
    var body: some View {
        Button(action: {
            active.toggle()
            generateHaptic(style: .light)
        }){
            VStack(alignment: .leading, spacing: 0) {
                org.cover
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipped()
                    .overlay(
                        VStack {
                            HStack {
                                org.logo
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: iconHeight)
                                    .frame(maxWidth: iconHeight * 2)
                                    .padding(5)
                                    .background(Color.white)
                                    .clipped()
                                    .cornerRadius(cornerRadius * 0.6)
                                    .fixedSize(horizontal: true, vertical: false)
                                    
                                Spacer()
                            }
                            .padding(8)
                            
                            Spacer()
                        }
                    )
                    .cornerRadius(cornerRadius)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(org.name)
                        .font(.system(.body, weight: .semibold))
                        .lineLimit(2)
                        .padding(.bottom, 1)
                    
                    Text(org.address)
                        .lineLimit(1)
                        .font(.footnote)
                }
                .padding(.vertical)
            }
            .contentShape(Rectangle())
            .frame(width: width)
        }
        .buttonStyle(ShrinkingButton())
        .sheet(isPresented: $active) {
            OrganizationView(organization: org)
        }
    }
}

struct BusinessCardWideView: View {
    @State var active: Bool = false
    let org: Organization
    
    let height: CGFloat = UIScreen.ScreenHeight * 0.3
    let cornerRadius: CGFloat = 12
    
    var iconHeight: CGFloat {
        return height * 0.2
    }
    
    var body: some View {
        Button(action: {
            active.toggle()
            generateHaptic(style: .light)
        }){
            VStack(alignment: .leading, spacing: 0) {
                org.cover
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: height * 0.6)
                    .clipped()
                    .overlay(
                        VStack {
                            HStack {
                                org.logo
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: iconHeight, height: iconHeight)
                                    .background(Color.white)
                                    .clipped()
                                    .cornerRadius(cornerRadius * 0.6)
                                
                                Spacer()
                            }
                            .padding(8)
                            
                            Spacer()
                        }
                    )
                    .cornerRadius(cornerRadius)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(org.name)
                        .font(.system(.body, weight: .semibold))
                        .lineLimit(2)
                        .padding(.bottom, 1)
                    
                    Text(org.address)
                        .lineLimit(1)
                        .font(.footnote)
                }
                .padding(.vertical)
            }
        }
        .buttonStyle(ShrinkingButton())
        .sheet(isPresented: $active) {
            OrganizationView(organization: org)
        }
    }
}

struct SearchBar: View {
    @Binding var search: String
    
    let cornerRadius: CGFloat = 6
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color.white
                    .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: lineWidth)
                    .overlay(Color("accentAlt"))
            }
            
            HStack {
                TextField("Search", text: $search)
                
                Spacer()
                Button(action: {
                    if !search.isEmpty {
                        search = ""
                        generateHaptic(style: .light)
                    }
                }){
                    if search.isEmpty {
                        Image(systemName: "magnifyingglass")
                            .fontWeight(.bold)
                    } else {
                        Image(systemName: "xmark")
                            .fontWeight(.bold)
                    }
                }
                .containerShape(Rectangle())
                .buttonStyle(ShrinkingButton())
            }
            .padding()
            .background(
                ZStack {
                    Color.white.cornerRadius(cornerRadius)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Color.black, lineWidth: lineWidth)
                }
            )
            .padding()
        }
    }
}
