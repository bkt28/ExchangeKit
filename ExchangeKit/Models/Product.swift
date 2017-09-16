//
//  Product.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct Product: Mappable {
    
    fileprivate(set) var id: String = ""
    fileprivate(set) var baseCurrency: String = ""
    fileprivate(set) var quoteCurrency: String = ""
    fileprivate(set) var baseMinimumSize: Double = 0.0
    fileprivate(set) var baseMaximumSize: Double = 0.0
    fileprivate(set) var quoteIncrement: Double = 0.0
    fileprivate(set) var displayName: String = ""
    
    fileprivate(set) var symbol: String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        let transformDoubleString = TransformOf<Double, String>(fromJSON: { (value: String?) -> Double? in
            return Double(value ?? "0.0")
        }, toJSON: { (value: Double?) -> String? in
            if let value = value {
                return String(value)
            }
            return nil
        })
        
        id                  <- map["id"]
        baseCurrency        <- map["base_currency"]
        quoteCurrency       <- map["quote_currency"]
        baseMinimumSize     <- (map["base_min_size"], transformDoubleString)
        baseMaximumSize     <- (map["base_max_size"], transformDoubleString)
        quoteIncrement      <- (map["quote_increment"], transformDoubleString)
        displayName         <- map["display_name"]
        
    }
    
    func getSymbol() -> String {
        
        switch quoteCurrency {
            case "USD":
                return "$"
            
            case "EUR":
                return "€"
            
            case "GBP":
                return "£"
            
            case "BTC":
                return "₿"
            
            default:
                return ""
        }
        
    }
    
}
