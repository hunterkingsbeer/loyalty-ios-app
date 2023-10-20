//
//  BusinessView.swift
//  Loyalty
//
//  Created by Hunter Kingsbeer on 10/09/23.
//

import SwiftUI
import CachedAsyncImage

struct OrganizationView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationView(organization: OrgPattisAndCream)
            .environmentObject(StateService())
    }
}

struct OrganizationView: View {
    var organization: Organization
    
    @State var viewingAboutSection: Bool = true
    
    var body: some View {
        ZStack(alignment: .top) {
            organization.cover
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.ScreenWidth,
                       height: UIScreen.ScreenHeight * 0.3)
                .clipped()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Section {
                        ZStack(alignment: .leading) {
                            if viewingAboutSection {
                                AboutSectionView(organization: organization, viewingAboutSection: $viewingAboutSection)
                                    .transition(.offset(x: -UIScreen.ScreenWidth))
                                    .animation(.spring(), value: viewingAboutSection)
                            } else if organization.type.info.bookingType.allowsBooking {
                                AppointmentsSectionView(organization: organization)
                                    .transition(.offset(x: UIScreen.ScreenWidth))
                                    .animation(.spring(), value: viewingAboutSection)
                            }
                        }
                        .animation(.spring(), value: viewingAboutSection)
                    } header: {
                        OrganizationHeader(organization: organization, viewingAboutSection: $viewingAboutSection)
                    }
                }
                .padding(.top, 150)
            }
        }
//        .ignoresSafeArea(edges: .top)
    }
}
