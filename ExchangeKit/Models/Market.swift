//
//  Market.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import UIKit

class Market {
    
    // MARK: - Properties
    var productId: String
    var name: String
    var price: Double {
        didSet {
            setPercentChange()
        }
    }
    var openPrice: Double = 0.0 {
        didSet {
            setPercentChange()
        }
    }
    var percentChange: Double = 0.0
    var isPriceUp: Bool = false
    
    // MARK: - Initialization
    init(productId: String, name: String, price: Double) {
        
        self.productId = productId
        self.name = name
        self.price = price
        
    }
    
    private func setPercentChange() {
        
        if openPrice != 0.0 {
            percentChange = (price / openPrice - 1.0) * 100.00
        }
        
        isPriceUp = percentChange >= 0.0
        
    }
    
}
