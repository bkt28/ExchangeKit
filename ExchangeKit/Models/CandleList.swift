//
//  CandleList.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct CandleList: Mappable {
    
    fileprivate(set) var candles: [[Any]] = [[Any]]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        candles <- map["response"]
        
    }
    
}
