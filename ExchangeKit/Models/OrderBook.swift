//
//  OrderBook.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct OrderBook: Mappable {
    
    fileprivate(set) var sequence: Int = 0
    fileprivate(set) var bids: [[Any]] = [[Any]]()
    fileprivate(set) var asks: [[Any]] = [[Any]]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        sequence    <- map["sequence"]
        bids        <- map["bids"]
        asks        <- map["asks"]
        
    }

}
