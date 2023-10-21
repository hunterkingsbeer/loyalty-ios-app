//
//  CardView.swift
//  LoyaltyApp
//
//  Created by Hunter Kingsbeer on 25/09/23.
//

import SwiftUI

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CardView(org: OrgFreshPrinceBarbers)
                .padding()
                .environmentObject(StateService())
            
            CardAccountView(account: DefaultAccount)
                .padding()
                .environmentObject(StateService())
            
            CardDefaultView()
                .padding()
        }
    }
}

struct CardView: View {
    @EnvironmentObject var stateService: StateService
    
    var org: Organization
    
    var enableSheet: Bool = false
    
    var cornerRadius: CGFloat = 16
    var height: CGFloat = UIScreen.ScreenHeight * 0.24
    var strokeColor: Color = Color.black
    
    @State var active = false
    
    var logoSize: CGFloat {
        return height * 0.5
    }
    
    var body: some View {
        Button(action: {
            generateHaptic(style: .light)
            if enableSheet {
                active.toggle()
            }
        }){
            ZStack {
                ZStack(alignment: .trailing) {
                    Color.white
                    
                    LinearGradient(gradient: Gradient(colors: [org.color, Color.white]), startPoint: .top, endPoint: .bottom)
                        .frame(width: 6)
                }
                .cornerRadius(cornerRadius)
                .containerShape(RoundedRectangle(cornerRadius: cornerRadius))
                .shadow(color: Color("coreGrey").opacity(0.2), radius: 3)
                    
                VStack(alignment: .leading, spacing: 0) {
                    org.logo
                        .scaledToFit()
                        .frame(height: logoSize)
                        .frame(maxWidth: logoSize * 1.5)
                        .clipped()
                        .background(.white)
                        .cornerRadius(cornerRadius * 0.8)
                    
                    Spacer()
                    
                    // name + icon
                    HStack {
                        VStack(alignment: .leading) {
                            Text(org.address)
                                .font(.subheadline)
                            Text(org.name)
                                .font(.system(.body, weight: .semibold))
                        }
                        
                        Spacer()
                        
                        org.type.info.icon
                            .font(.system(.title, weight: .semibold))
                            .foregroundColor(org.color)
                    }
                }
                .padding()
            }
            .frame(height: height)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .buttonStyle(ShrinkingButton())
        .sheet(isPresented: $active) {
            OrganizationView(organization: org)
        }
    }
}

struct CardAccountView: View {
    var account: Account
    
    var cornerRadius: CGFloat = 16
    var height: CGFloat = UIScreen.ScreenHeight * 0.24
    var strokeColor: Color = Color.black
    
    var logoSize: CGFloat {
        return height * 0.5
    }
    
    var body: some View {
        ZStack {
            ZStack(alignment: .trailing) {
                Color.white

                LinearGradient(gradient: Gradient(colors: [Color("green"), Color.white]), startPoint: .top, endPoint: .bottom)
                    .frame(width: 6)
            }
            .cornerRadius(cornerRadius)
            .containerShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color("coreGrey").opacity(0.2), radius: 3)
                
            
            VStack {
                // logo + qr
                HStack {
                    account.profileImage
                        .scaledToFit()
                        .frame(height: logoSize)
                        .frame(maxWidth: logoSize)
                        .clipped()
                        .background(.white)
                        .cornerRadius(cornerRadius * 0.8)
                    
                    Spacer()
                    
                    Image.qrCodeImage(for: account.username)?
                        .resizable()
                        .frame(width: logoSize, height: logoSize)
                }
                .padding()
                
                Spacer()
                
                // name + icon
                HStack {
                    VStack(alignment: .leading) {
                        Text(account.email)
                            .font(.footnote)
                        
                        Text("\(account.firstName.capitalizingFirstLetter()) \(account.lastName.capitalizingFirstLetter())")
                            .lineLimit(1)
                            .minimumScaleFactor(0.2)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "person.and.background.dotted")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color("text"), Color("green"))
                }
                .font(.system(.title, weight: .semibold))
                .padding()
                .padding(.leading, 6)
            }
        }
        .frame(height: height)
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}


struct CardDefaultView: View {
    var cornerRadius: CGFloat = 16
    var height: CGFloat = UIScreen.ScreenHeight * 0.24
    var color: Color = Color.white
    var text: String = "Welcome"
    
    var logoSize: CGFloat {
        return height * 0.5
    }
    
    var body: some View {
        ZStack {
            ZStack(alignment: .trailing) {
                color

                LinearGradient(gradient: Gradient(colors: [Color("green"), Color.white.opacity(0)]), startPoint: .top, endPoint: .bottom)
                    .frame(width: 6)
            }
            .cornerRadius(cornerRadius)
            .containerShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color("coreGrey").opacity(0.2), radius: 3)
            
            
            VStack {
                // logo
                HStack(alignment: .top) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: logoSize)
                        .frame(width: logoSize)
                    
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                // name + icon
                HStack {
                    Text(text)
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                    
                    Spacer()
                    
                    Image(systemName: "cloud.bolt")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color("text"), Color("green"))
                }
                .font(.system(.title, weight: .semibold))
                .padding()
                .padding(.trailing, 6)

            }
        }
        .frame(height: height)
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
