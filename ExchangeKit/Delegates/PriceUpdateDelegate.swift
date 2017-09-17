//
//  PriceUpdateDelegate.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation

protocol PriceUpdateDelegate: class {
    
    func didReceivePriceUpdate(productId: String, price: Double)
    
}
