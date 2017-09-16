//
//  Fill.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct Fill: Mappable {
    
    fileprivate(set) var tradeId: Int = 0
    fileprivate(set) var productId: String = ""
    fileprivate(set) var price: Double = 0.0
    fileprivate(set) var size: Double = 0.0
    fileprivate(set) var orderId: String = ""
    fileprivate(set) var createdAt: String = ""
    fileprivate(set) var liquidity: String = ""
    fileprivate(set) var fee: Double = 0.0
    fileprivate(set) var settled: Bool = false
    fileprivate(set) var side: String = ""
    
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
        productId   <- map["product_id"]
        price       <- (map["price"], transformDoubleString)
        size        <- (map["size"], transformDoubleString)
        orderId     <- map["order_id"]
        createdAt   <- map["created_at"]
        liquidity   <- map["liquidity"]
        fee         <- map["fee"]
        settled     <- map["settled"]
        side        <- map["side"]
        
    }
    
}
