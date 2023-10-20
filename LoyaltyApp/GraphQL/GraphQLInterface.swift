//
//  GraphQLInterface.swift
//  LoyaltyApp
//
//  Created by Hunter Kingsbeer on 21/09/23.
//

import Foundation
import SwiftUI
import Apollo

internal class Network {
    static let shared = Network()

    private init() {}

    private(set) lazy var apollo = ApolloClient(url: URL(string: "http://loyalty-api-loadbalancer-455480432.ap-southeast-2.elb.amazonaws.com/graphql/")!)
//
//    private(set) lazy var apollo = ApolloClient(url: URL(string: "http://localhost:5112/graphql/")!)
    
    

}
