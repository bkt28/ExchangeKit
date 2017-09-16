//
//  AccountList.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct AccountList: Mappable {
    
    fileprivate(set) var accounts: [Account] = [Account]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        accounts <- map["response"]
        
    }
    
}
