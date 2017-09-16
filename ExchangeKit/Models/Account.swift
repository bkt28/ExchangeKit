//
//  Account.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct Account: Mappable {
    
    fileprivate(set) var id: String = ""
    fileprivate(set) var currency: String = ""
    fileprivate(set) var balance: Double = 0.0
    fileprivate(set) var available: Double = 0.0
    fileprivate(set) var hold: Double = 0.0
    fileprivate(set) var profileId: String = ""
    
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
        
        id          <- map["id"]
        currency    <- map["currency"]
        balance     <- (map["balance"], transformDoubleString)
        available   <- (map["available"], transformDoubleString)
        hold        <- (map["hold"], transformDoubleString)
        profileId   <- map["profile_id"]
        
    }
    
}
