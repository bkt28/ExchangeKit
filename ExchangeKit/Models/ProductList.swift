//
//  Products.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import ObjectMapper

struct ProductList: Mappable {
    
    fileprivate(set) var products: [Product] = [Product]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        products <- map["response"]
        
    }
    
}
