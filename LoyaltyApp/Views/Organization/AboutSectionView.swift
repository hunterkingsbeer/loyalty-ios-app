//
//  AboutSectionView.swift
//  LoyaltyApp
//
//  Created by Hunter Kingsbeer on 25/09/23.
//

import SwiftUI

struct AboutSectionView_Previews: PreviewProvider {
    static var previews: some View {
        AboutSectionView(organization: OrgFreshPrinceBarbers, viewingAboutSection: .constant(true))
    }
}

struct AboutSectionView: View {
    let organization: Organization
    @Binding var viewingAboutSection: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            BookNowButton(viewingAboutSection: $viewingAboutSection,
                          text: (organization.type.info.bookingType == .Appointment ?  "Book an appointment" : "Reserve a table"),
                          color: organization.color)
                .padding(.horizontal)
            
            if !organization.imageUrls.isEmpty {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<organization.images.count){ image in
                                organization.images[image]
                                    .frame(width: UIScreen.ScreenWidth * 0.6, height: UIScreen.ScreenWidth * 0.6)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                }
            }
            
            if !organization.employees.isEmpty {
                OrganizationPeopleView(organization: organization,
                                       viewingAboutSection: $viewingAboutSection)
                    .padding()
            }
        }
        .padding(.vertical)
        .background(Color.white)
    }
}

struct OrganizationPeopleView: View {
    let organization: Organization
    @Binding var viewingAboutSection: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("People")
                .font(.system(.title, weight: .semibold))
                .padding(.vertical, 10)
                .foregroundColor(organization.color)
                .brightness(-0.5)
            
            Divider()
                .frame(height: lineWidth)
                .overlay(Color("accentAlt"))
                .padding(.bottom)
            
            ForEach(organization.employees.sorted(by: { $0.position > $1.position})) { employee in
                EmployeeView(employee: employee)
                .padding(.bottom)
            }
        }
    }
}

struct BookNowButton: View {
    @Binding var viewingAboutSection: Bool
    
    let text: String
    var color: Color = Color.black
    
    var body: some View {
        Button(action: {
            viewingAboutSection.toggle()
            generateHaptic(style: .light)
        }){
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.08))
                
                HStack {
                    Text(text)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack {
                        Text("Available tomorrow")
                            .underline()
                        Image(systemName: "arrow.right")
                    }
                    .font(.footnote)
                }
                .foregroundColor(color)
                .brightness(-0.5)
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .buttonStyle(ShrinkingButton())
    }
}

struct EmployeeView: View {
    let employee: Employee
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(employee.firstName) \(employee.lastName)")
                        .font(.system(.title, weight: .semibold))
                    
                    HStack() {
                        Text("\(employee.position)")
                            .fontWeight(.semibold)
                            .foregroundColor(employee.organizationMetadata.color)
                            .brightness(-0.5)
                        
                        Image(systemName: "circle.fill")
                            .font(.system(size: 2.5))
                        
                        Text("Since \(employee.dateStartedFormatted)")
                    }
                }
                
                Spacer()
                
                employee.profileImage
                    .scaledToFit()
                    .frame(width: UIScreen.ScreenHeight * 0.08, height: UIScreen.ScreenHeight * 0.08)
                    .clipped()
                    .cornerRadius(99)
            }
            .padding(.bottom, 6)
            
            Text(employee.description)
        }
    }
}
