//
//  OrderUpdateDelegate.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation

protocol OrderUpdateDelegate: class {
    
    func didReceiveOrder(orderId: String, productId: String, type: String, side: String, price: Double, size: Double)
    
    func didCloseOrder(orderId: String, productId: String, side: String)
    
}
