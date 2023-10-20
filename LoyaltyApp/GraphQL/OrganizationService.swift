//
//  OrganizationService.swift
//  LoyaltyApp
//
//  Created by Hunter Kingsbeer on 25/09/23.
//

import Foundation

func apiEnum(orgType: OrganizationType) -> GraphQLEnum<LoyaltyAPI.OrganizationType> {
    switch orgType {
    case .Barber:
        return GraphQLEnum<LoyaltyAPI.OrganizationType>.case(.barber)
    case .Salon:
        return GraphQLEnum<LoyaltyAPI.OrganizationType>.case(.salon)
    case .Health:
        return GraphQLEnum<LoyaltyAPI.OrganizationType>.case(.health)
    default:
        return GraphQLEnum<LoyaltyAPI.OrganizationType>.case(.unknown)
    }
}

private func toOrganizationType(type: GraphQLEnum<LoyaltyAPI.OrganizationType>) -> OrganizationType {
    return OrganizationType(rawValue: type.rawValue) ?? OrganizationType.Unknown
}

// For ALL organizations
class OrganizationsService: ObservableObject {
    @Published var organizations: [Organization] = []
    var organizationsLoaded: Bool = false
    
    init() {
        FetchOrganizations()
    }
    
    func ofType(orgType: OrganizationType) -> [Organization] {
        return organizations.filter { $0.type == orgType }
    }
    
    private func toOrganization(org: LoyaltyAPI.AllOrganizationsQuery.Data.GetAllOrganization) -> Organization {
        func toEmployee(employee: LoyaltyAPI.AllOrganizationsQuery.Data.GetAllOrganization.Employee) -> Employee {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//            let dateStarted = formatter.date(from: employee.dateStarted)!
            
            let dateStarted = ISO8601DateFormatter().date(from: employee.dateStarted.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression))!
            
            return Employee(username: employee.username!,
                            firstName: employee.firstName!,
                            lastName: employee.lastName!,
                            description: employee.description!,
                            position: employee.position!,
                            profileUrl: employee.media!.profileImage!,
                            dateStarted: dateStarted,
                            organizationMetadata: OrganizationMetadata(name: org.name!, username: org.username!, type: toOrganizationType(type: org.type), color: org.color!))
        }
        
        let employees = org.employees != nil ? org.employees!.map { toEmployee(employee: $0!) } : []
        return Organization(username: org.username!,
                            name: org.name!,
                            type: toOrganizationType(type: org.type),
                            description: org.description!,
                            address: org.address!,
                            logo: org.media?.logo ?? defaultImageUrl.absoluteString,
                            cover: org.media?.cover ?? defaultImageUrl.absoluteString,
                            images: ((org.media?.images ?? []).map { $0! }),
                            color: org.color ?? "accentAlt",
                            employees: employees)
    }
    
    func GetOrganization(username: String) -> Organization? {
        let org = organizations.filter { $0.username == username }
        
        if org.isEmpty {
            return nil
        } else {
            return org[0]
        }
    }
    
    func FetchOrganizations() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            self.organizations = allOrgs
            self.organizationsLoaded = true
        } else {
            let query = LoyaltyAPI.AllOrganizationsQuery()
            
            Network.shared.apollo.fetch(query: query,
                                        cachePolicy: .fetchIgnoringCacheData) { result in
                switch result {
                case .success(let graphQLResult):
                    if let orgs = graphQLResult.data?.getAllOrganizations {
                        self.organizations = orgs.map{ self.toOrganization(org: $0!) }.sorted { $0.name > $1.name}
                        self.organizationsLoaded = true
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
