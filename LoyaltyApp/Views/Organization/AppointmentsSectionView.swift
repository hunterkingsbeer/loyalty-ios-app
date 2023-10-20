//
//  AppointmentsSectionView.swift
//  LoyaltyApp
//
//  Created by Hunter Kingsbeer on 25/09/23.
//

import SwiftUI

struct AppointmentsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            AppointmentsSectionView(organization: OrgFreshPrinceBarbers)
            
            HStack { Spacer() }
        }
    }
}

struct AppointmentsSectionView: View {
    let organization: Organization
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Your Appointments")
                    .font(.system(.body, weight: .semibold))
                
                AppointmentCardDetailsView(organization: organization,
                                           appointmentActivity: "Beard trim",
                                           subtitle: "2pm Wednesday, 19th August.")
                
                AppointmentCardDetailsView(organization: organization,
                                           appointmentActivity: "Haircut",
                                           subtitle: "Ready Friday, 21st August.")
                
                AppointmentCardDetailsView(organization: organization,
                                           appointmentActivity: "Beard trim",
                                           subtitle: "2pm Wednesday, 19th August.")
                
                AppointmentCardDetailsView(organization: organization,
                                           appointmentActivity: "Haircut",
                                           subtitle: "Ready Friday, 21st August.")
                
                Spacer()
            }
            .padding()
            
            VStack {
                Text("Book an appointment")
                    .font(.system(.body, weight: .semibold))
            }.padding()
            
            HStack {
                Spacer()
            }
            Spacer()
        }
        .background(Color.white)
    }
}

struct AppointmentCardDetailsView: View {
    let organization: Organization
    let appointmentActivity: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(appointmentActivity)
                    .font(.system(.title, weight: .semibold))
            }
            
            Text(subtitle)
        }
        .padding(.leading, 10)
        .background(
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 4)
//                    .foregroundColor(organization.type.info.color)
                    .foregroundColor(Color.black)
                Spacer()
            }
        )
    }
}
