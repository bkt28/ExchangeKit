//
//  ProductTicker.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct ProductTicker: Mappable {
    
    fileprivate(set) var tradeId: String = ""
    fileprivate(set) var price: Double = 0.0
    fileprivate(set) var size: Double = 0.0
    fileprivate(set) var bid: Double = 0.0
    fileprivate(set) var ask: Double = 0.0
    fileprivate(set) var volume: Double = 0.0
    fileprivate(set) var time: Date = Date()
    
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
        
        tradeId     <- map["trade_id"]
        price       <- (map["price"], transformDoubleString)
        size        <- (map["size"], transformDoubleString)
        bid         <- (map["bid"], transformDoubleString)
        ask         <- (map["ask"], transformDoubleString)
        volume      <- (map["volume"], transformDoubleString)
        time        <- (map["time"], ISO8601DateTransform())
        
    }
    
}
