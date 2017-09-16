//
//  OrderResponse.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct OrderResponse: Mappable {
    
    fileprivate(set) var id: String = ""
    fileprivate(set) var price: Double = 0.0
    fileprivate(set) var size: Double = 0.0
    fileprivate(set) var productId: String = ""
    fileprivate(set) var side: String = ""
    fileprivate(set) var stp: String = ""
    fileprivate(set) var type: String = ""
    fileprivate(set) var timeInForce: String = ""
    fileprivate(set) var postOnly: Bool = false
    fileprivate(set) var createdAt: String = ""
    fileprivate(set) var fillFees: Double = 0.0
    fileprivate(set) var filledSize: Double = 0.0
    fileprivate(set) var executedValue: Double = 0.0
    fileprivate(set) var status: String = ""
    fileprivate(set) var settled: Bool = false
    
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
        
        id              <- map["id"]
        price           <- (map["price"], transformDoubleString)
        size            <- (map["size"], transformDoubleString)
        productId       <- map["product_id"]
        side            <- map["side"]
        stp             <- map["stp"]
        type            <- map["type"]
        timeInForce     <- map["time_in_force"]
        postOnly        <- map["post_only"]
        createdAt       <- map["created_at"]
        fillFees        <- (map["fill_fees"], transformDoubleString)
        filledSize      <- (map["filled_size"], transformDoubleString)
        executedValue   <- (map["executed_value"], transformDoubleString)
        status          <- map["status"]
        settled         <- map["settled"]
        
    }
    
}
