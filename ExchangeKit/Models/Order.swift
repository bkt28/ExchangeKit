//
//  Order.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation

struct Order {
    
    fileprivate(set) var id: String
    fileprivate(set) var productId: String
    fileprivate(set) var type: String
    fileprivate(set) var side: String
    fileprivate(set) var price: Double
    fileprivate(set) var size: Double
    
    init(id: String, productId: String, type: String, side: String, price: Double, size: Double) {
        
        self.id = id
        self.productId = productId
        self.type = type
        self.side = side
        self.price = price
        self.size = size
        
    }
    
}
