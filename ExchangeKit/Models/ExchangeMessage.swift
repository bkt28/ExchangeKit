//
//  ExchangeMessage.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct ExchangeMessage: Mappable {
    
    fileprivate(set) var type: String = ""
    fileprivate(set) var tradeId: Int = 0
    fileprivate(set) var sequence: Int = 0
    fileprivate(set) var orderId: String = ""
    fileprivate(set) var makerOrderId: String = ""
    fileprivate(set) var takerOrderId: String = ""
    fileprivate(set) var time: Date = Date()
    fileprivate(set) var productId: String = ""
    fileprivate(set) var size: Double = 0.0
    fileprivate(set) var price: Double = 0.0
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
        
        let transformIntString = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
            return Int(value ?? "0")
        }, toJSON: { (value: Int?) -> String? in
            if let value = value {
                return String(value)
            }
            return nil
        })
        
        type            <- map["type"]
        tradeId         <- (map["trade_id"], transformIntString)
        sequence        <- (map["sequence"], transformIntString)
        orderId         <- map["order_id"]
        makerOrderId    <- map["maker_order_id"]
        takerOrderId    <- map["taker_order_id"]
        time            <- (map["time"], ISO8601DateTransform())
        productId       <- map["product_id"]
        size            <- (map["size"], transformDoubleString)
        price           <- (map["price"], transformDoubleString)
        side            <- map["side"]
        
    }
    
}
