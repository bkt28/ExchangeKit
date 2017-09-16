//
//  CancelledOrdersList.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct CancelledOrdersList: Mappable {
    
    fileprivate(set) var cancelledOrders: [String] = [String]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        cancelledOrders <- map["response"]
        
    }
    
    
}
