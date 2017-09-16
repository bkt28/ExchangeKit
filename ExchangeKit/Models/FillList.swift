//
//  FillList.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct FillList: Mappable {
    
    fileprivate(set) var fills: [Fill] = [Fill]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        fills <- map["response"]
        
    }
    
}
