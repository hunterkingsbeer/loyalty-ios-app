//
//  AccountService.swift
//  LoyaltyApp
//
//  Created by Hunter Kingsbeer on 26/09/23.
//

import Foundation
import SwiftUI
import Auth0

enum AccountLoadState {
    case AuthCheck // default
    case AuthFail // no existing or valid creds
    
    case AccountLoading // loading account from dynamoDB
    case AccountNotFound // no account found in dynamoDB
    
    case Error // exception occured
    case Success // full success, app loaded
}

// For SINGLE organization
class StateService: ObservableObject {
    @Published var account: Account?
    @Published var state: AccountLoadState = .AuthCheck
    @Published var username: String = IS_PREVIEW ? "hi@hunterkingsbeer.com" : ""
    var loginSuccess: Bool {
        return self.state == .Success
    }
    
    // ------------------------- TEST STATE -----------------------
    private let testState: AccountLoadState = .Success
    
    private let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    
    init() {
        if IS_PREVIEW {
            self.account = DefaultAccount
            self.state = testState
        }
    }
    
    // ------------------------------------------------------------
    // ----------------------  AUTHENTICATION  --------------------
    // ------------------------------------------------------------
    
    func authenticate(state: AccountLoadState){
        if IS_PREVIEW {
            return self.state = testState
        }
        
        print(state)
        switch state {
        // 1. Auth0
        case .AuthCheck:
            // check for existing session
            checkSession()
            break
        case .AuthFail:
            // show login view
            break
            
        // 2. DynamoDB
        case .AccountLoading:
            // load account from DynamoDB
            self.FetchAccount(username: username)
        case .AccountNotFound:
            // show create account view
            print("Found email \(username)")
            break
            
        // 3. Result
        case .Error:
            // show error view
            break;
        case .Success:
            // hell yea
            print("Logged in user \(username)")
            break;
        }
    }
    
    func checkSession() {
        if IS_PREVIEW {
            return self.state = testState
        }
        
        guard credentialsManager.hasValid() else {
            // No renewable credentials exist, present the login page
            print("No valid credentials found")
            state = .AuthFail
            return
        }
        
        credentialsManager.credentials { result in
            switch result {
            case .success(let credentials):
                let user = User(from: credentials.idToken)
                
                if let email = user?.email {
                    DispatchQueue.main.async{
                        let _ = self.credentialsManager.store(credentials: credentials)
                        
                        self.username = email
                        self.state = .AccountLoading
                    }
                }
            case .failure(_):
                self.state = .AuthFail
            }
        }
    }
    
    func login() {
        if IS_PREVIEW {
            return self.state = testState
        }
        
        Auth0
            .webAuth()
            .parameters(["prompt": "login"])
            .start { result in
                switch result {
                case .success(let credentials):
                    let user = User(from: credentials.idToken)
                    let _ = self.credentialsManager.store(credentials: credentials)
                    
                    if let email = user?.email {
                        self.username = email
                        self.state = .AccountLoading
                    }
                case .failure(let error):
                    print("Failed with: \(error)")
                    self.state = .AuthFail
                }
            }
    }
    
    func logout() {
        self.account = nil
        self.state = .AuthCheck
        self.username = ""
        let _ = self.credentialsManager.clear()
    }
    
    // ------------------------------------------------------------
    // -------------------------  ACCOUNT  ------------------------
    // ------------------------------------------------------------
    
    func GetAccount(username: String) -> Account? {
        if IS_PREVIEW {
            return DefaultAccount
        } else {
            var account: Account? = nil
            let query = LoyaltyAPI.AccountQuery(accountUsername: GraphQLNullable.some(username))
            
            Network.shared.apollo.fetch(query: query,
                                        cachePolicy: .fetchIgnoringCacheData) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors {
                        print(errors)
                    } else if let acc = graphQLResult.data?.getAccount {
                        account = self.ToAccount(account: acc)
                        print("Found account \(acc.username)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            return account
        }
    }
    
    // used on start up/log in
    func FetchAccount(username: String){
        if IS_PREVIEW {
            self.account = DefaultAccount
            self.state = .Success
        } else {
            let query = LoyaltyAPI.AccountQuery(accountUsername: GraphQLNullable.some(username))
            
            Network.shared.apollo.fetch(query: query,
                                        cachePolicy: .fetchIgnoringCacheData) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors {
                        print(errors)
                        self.state = .AccountNotFound
                    } else if let acc = graphQLResult.data?.getAccount {
                        self.account = self.ToAccount(account: acc)
                        self.username = acc.email ?? ""
                        self.state = .Success
                    }
                case .failure(let error):
                    self.state = .Error
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // silently reloads account info
    func ReloadAccount() {
        if IS_PREVIEW {
            self.account = DefaultAccount
        } else {
            let query = LoyaltyAPI.AccountQuery(accountUsername: GraphQLNullable.some(self.username))
            
            Network.shared.apollo.fetch(query: query,
                                        cachePolicy: .fetchIgnoringCacheData) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors {
                        print(errors)
                    } else if let acc = graphQLResult.data?.getAccount {
                        self.account = self.ToAccount(account: acc)
                        self.username = acc.email ?? ""
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func ToAccount(account: LoyaltyAPI.AccountQuery.Data.GetAccount) -> Account {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        let birthday = formatter.date(from: account.birthday)!
        
        return Account(username: account.username!,
                       email: account.email!,
                       firstName: account.firstName!,
                       lastName: account.lastName!,
                       birthday: birthday,
                       loyalties: account.loyalties as! [String]
        )
    }
    
    func UpdateLoyalties(orgUsernames: [String]) {
        if IS_PREVIEW {
            self.account = Account(username: account!.username,
                                   email: account!.email,
                                   firstName: account!.firstName,
                                   lastName: account!.lastName,
                                   birthday: account!.birthday,
                                   loyalties: orgUsernames)
        } else {
            let mutation = LoyaltyAPI.UpdateLoyaltiesMutation(accountUsername: GraphQLNullable.some(self.username), loyalties: GraphQLNullable.some(orgUsernames))
            Network.shared.apollo.perform(mutation: mutation)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.ReloadAccount()
            }
        }
    }
    
    func CreateAccount(email: String, first: String, last: String){
        if IS_PREVIEW {
            self.account = DefaultAccount
            self.state = .Success
        } else {
            let input =
            LoyaltyAPI.CreateAccountInput(username: GraphQLNullable.some(email),
                                          firstName: GraphQLNullable.some(first),
                                          lastName: GraphQLNullable.some(last),
                                          email: GraphQLNullable.some(email))
            let mutation = LoyaltyAPI.CreateAccountMutation(input: GraphQLNullable.some(input))
            
            Network.shared.apollo.perform(mutation: mutation) { result in
                switch result {
                case .success(let graphQLResult):
                    if let errors = graphQLResult.errors {
                        print(errors)
                        self.state = .AccountNotFound
                    } else if let _ = graphQLResult.data?.createAccount {
                        self.username = email
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.state = .AccountLoading
                        }
                    }
                case .failure(let error):
                    self.state = .Error
                    print(error.localizedDescription)
                }
            }
        }
    }
}
