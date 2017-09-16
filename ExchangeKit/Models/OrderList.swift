//
//  OrderList.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct OrderList: Mappable {
    
    fileprivate(set) var orders: [OrderResponse] = [OrderResponse]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        orders <- map["response"]
        
    }
    
}
