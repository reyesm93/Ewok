//
//  Constants.swift
//  Ewok
//
//  Created by Arturo Reyes on 2/24/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

extension PlaidClient {
    
    struct Constants {
        
        struct Request {
            
            struct Client {
                
                static let APIScheme = "https"
                static let APIHost = "sandbox.plaid.com"
                static let Post = "POST"
                
            }
            
            struct Products {
                
                static let auth = "/auth/get"
                static let transactions = "/transactions/get"
                static let balance = "/accounts/balance/get"
                static let categories = "/categories/get"
            }
            
            struct Item {
                
                static let account = "/account/get"
                static let item = "/item/get"
                static let webhook = "/item/webhook/update"
                static let invalidateAccessToken = "/item/access_token/invalidate"
                static let updateAccessToken = "/item/access_token/update_version"
                static let remove = "/item/remove"
                static let tokenExchange = "/item/public_token/exchange"
                static let tokenCreate = "/item/public_token/create"
            }
        }
        
        struct Response {
            
            struct Keys {
                
                static let accounts = "accounts"
                static let accountId = "accound_id"
                static let itemId = "item_id"
                static let accessToken = "access_token"
                
                struct Auth {
                    
                    static let balances = "balances"
                    static let available = "available"
                    static let current = "current"
                    static let limit = "limit"
                    static let mask = "mask"
                    static let name = "name"
                    static let officialName = "official_name"
                    static let subtype = "subtype"
                    static let type = "type"
                    static let numbers = "numbers"
                    static let account = "account"
                    static let wireRouting = "wire_routing"
                    static let item = "item"
                    static let requestId = "request_id"
                    
                }
                
                struct Transactions {
                    
                    static let transactions = "transactions"
                    static let amount = "amount"
                    static let category = "category"
                    static let categoryId = "category_id"
                    static let date = "date"
                    static let location = "location"
                    static let address = "address"
                    static let city = "city"
                    static let zip = "zip"
                    static let lat = "lat"
                    static let lon = "lon"
                    static let name = "name"
                    static let paymentMeta = "payment_meta"
                    static let pending = "pending"
                    static let pendingTransId = "pending_transaction_id"
                    static let accountOwner = "account_owner"
                    static let transactionId = "transaction_id"
                    static let transactionType = "transaction_type"
                    
                }
                
                
            }
        }
        
        struct JSON {
            static let App = "application/json"
            static let Accept = "Accept"
            static let Content = "Content-Type"
        }
    }
}
