//
//  MarketStats.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct MarketStats: Mappable {
    
    fileprivate(set) var open: Double = 0.0
    fileprivate(set) var high: Double = 0.0
    fileprivate(set) var low: Double = 0.0
    fileprivate(set) var volume: Double = 0.0
    
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
        
        open    <- (map["open"], transformDoubleString)
        high    <- (map["high"], transformDoubleString)
        low     <- (map["low"], transformDoubleString)
        volume  <- (map["volume"], transformDoubleString)
        
    }
    
}
