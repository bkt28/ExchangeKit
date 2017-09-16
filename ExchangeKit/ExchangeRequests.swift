//
//  ExchangeRequests.swift
//  ExchangeKit
//
//  Created by Brendan Taylor on 9/16/17.
//  Copyright © 2017 Brendan Taylor. All rights reserved.
//

import Foundation
import UIKit

import CryptoSwift
import ObjectMapper
import Starscream

let kExchangeRestApiURL: URL = URL(string: "https://api-public.sandbox.gdax.com")!
let kExchangeWebSocketURL: URL = URL(string: "https://ws-feed-public.sandbox.gdax.com")!

private let kExchangeAccessKey: String = "b360d58e343a9ec17c5c7e3a7340d4c5"
private let kExchangeSecret: Data = Data(base64Encoded: "uyQSr4FrDHiID3QzNIzbHS3cYM+RRGqvvkC0dydbe1VqPnwP7xTkBPk8/+IJQ+wxgcT6uOV9YMPOGxdJRDNZRA==")!
private let kExchangePassphrase: String = "3utgxt0cbcc"

struct ExchangeError {
    let errorMessage: String
}

protocol PriceUpdateDelegate: class {
    
    func didReceivePriceUpdate(productId: String, price: Double)
    
}

protocol OrderUpdateDelegate: class {
    
    func didReceiveOrder(orderId: String, productId: String, type: String, side: String, price: Double, size: Double)
    
    func didCloseOrder(orderId: String, productId: String, side: String)
    
}

class Exchange {
    
    static let shared: Exchange = Exchange()
    
    fileprivate let exchangeWebSocket: WebSocket = WebSocket(url: kExchangeWebSocketURL)
    
    fileprivate(set) var products: [Product] = [Product]()
    
    weak var priceUpdateDelegate: PriceUpdateDelegate?
    weak var orderUpdateDelegate: OrderUpdateDelegate?
    
    var currentExchangeTime: Date {
        get {
            return Date(timeIntervalSinceNow: 0.0)
        }
    }
    
    // Create a new exchange request
    
    fileprivate func request(relativePath: String, method: String, params: [String: Any]?) -> URLRequest {
        
        let requestURL: URL? = URL(string: relativePath, relativeTo: kExchangeRestApiURL)
        
        var request: URLRequest = URLRequest(url: requestURL!)
        
        request.httpMethod = method
        
        if let params = params as [String: AnyObject]? {
            
            if method == "GET" {
                
                var queryItems: [URLQueryItem] = [URLQueryItem]()
                
                for (key, value) in params {
                    queryItems.append(URLQueryItem(name: key, value: value as? String))
                }
                
                var components: URLComponents = URLComponents(url: requestURL!, resolvingAgainstBaseURL: true)!
                
                components.queryItems = queryItems
                
                request.url = components.url
                
            }
                
            else {
                
                let jsonData = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            }
            
        }
        
        return request
        
    }
    
    // Send an exchange request
    
    fileprivate func sendRequest<T: BaseMappable>(_ request: URLRequest, shouldAuthenticate: Bool, shouldParseResponse: Bool, completion: @escaping (_ error: ExchangeError?, _ response: T?) -> ()) {
        
        var request = request
        
        if shouldAuthenticate {
            
            let timestamp = Int(currentExchangeTime.timeIntervalSince1970)
            let requestPath = request.url?.path
            
            let message = "\(timestamp)" + (request.httpMethod ?? "GET") + requestPath! + (String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")
            let messageBytes = message.utf8.map({$0})
            
            let secretBytes = kExchangeSecret.bytes
            
            guard let hmac = try? HMAC(key:secretBytes, variant:.sha256).authenticate(messageBytes) else {
                
                print("Error: Could not generate HMAC for signature")
                completion(ExchangeError(errorMessage: "Could not generate HMAC for signature"), nil)
                
                return
                
            }
            
            guard let signature = hmac.toBase64() else {
                
                print("Error: Could not convert HMAC to base 64")
                completion(ExchangeError(errorMessage: "Could not convert HMAC to base 64"), nil)
                
                return
                
            }
            
            request.addValue(kExchangeAccessKey, forHTTPHeaderField: "CB-ACCESS-KEY")
            request.addValue(signature, forHTTPHeaderField: "CB-ACCESS-SIGN")
            request.addValue("\(timestamp)", forHTTPHeaderField: "CB-ACCESS-TIMESTAMP")
            request.addValue(kExchangePassphrase, forHTTPHeaderField: "CB-ACCESS-PASSPHRASE")
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard (response as? HTTPURLResponse) != nil else {
                return
            }
            
            guard shouldParseResponse else {
                return
            }
            
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
                completion(ExchangeError(errorMessage: "Server did not return valid JSON"), nil)
                
                return
            }
            
            if let jsonArray = json as? [Any] {
                
                let jsonObject: [String: Any] = ["response": jsonArray]
                
                guard let modelObject = Mapper<T>().map(JSON: jsonObject) else {
                    completion(ExchangeError(errorMessage: "Could not parse JSON into model"), nil)
                    
                    return
                }
                
                completion(nil, modelObject)
                
            }
                
            else if let jsonObject = json as? [String: Any] {
                
                guard let modelObject = Mapper<T>().map(JSON: jsonObject) else {
                    completion(ExchangeError(errorMessage: "Could not parse JSON into model"), nil)
                    
                    return
                }
                
                completion(nil, modelObject)
                
            }
                
            else {
                completion(ExchangeError(errorMessage: "Could not parse JSON into model. Not a dictionary or array"), nil)
                
                return
            }
            
            }
            .resume()
        
    }
    
    fileprivate func createJSON(dictionary: [String: Any]) -> String {
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []), let jsonString = String(data: jsonData, encoding: .utf8) else {
            return ""
        }
        
        return jsonString
        
    }
    
    // MARK: - API request methods
    
    func getProducts(completion: @escaping (_ error: ExchangeError?, _ response: ProductList?) -> ()) {
        let productsRequest = request(relativePath: "/products", method: "GET", params: nil)
        
        sendRequest(productsRequest, shouldAuthenticate: false, shouldParseResponse: true, completion: completion)
    }
    
    func getProductTicker(productId: String, completion: @escaping (_ error: ExchangeError?, _ response: ProductTicker?) -> ()) {
        let tickerRequest = request(relativePath: "/products/\(productId)/ticker", method: "GET", params: nil)
        
        sendRequest(tickerRequest, shouldAuthenticate: false, shouldParseResponse: true, completion: completion)
    }
    
    func getMarketStats(productId: String, completion: @escaping (_ error: ExchangeError?, _ response: MarketStats?) -> ()) {
        let statsRequest = request(relativePath: "/products/\(productId)/stats", method: "GET", params: nil)
        
        sendRequest(statsRequest, shouldAuthenticate: false, shouldParseResponse: true, completion: completion)
    }
    
    func getAccounts(completion: @escaping (_ error: ExchangeError?, _ response: AccountList?) -> ()) {
        let accountRequest = request(relativePath: "/accounts", method: "GET", params: nil)
        
        sendRequest(accountRequest, shouldAuthenticate: true, shouldParseResponse: true, completion: completion)
    }
    
    func placeOrder(params: [String: Any], completion: @escaping (_ error: ExchangeError?, _ response: OrderResponse?) -> ()) {
        let orderRequest = request(relativePath: "/orders", method: "POST", params: params)
        
        sendRequest(orderRequest, shouldAuthenticate: true, shouldParseResponse: true, completion: completion)
    }
    
    func getOrders(productId: String, completion: @escaping (_ error: ExchangeError?, _ response: OrderList?) -> ()) {
        let orderListRequest = request(relativePath: "/orders", method: "GET", params: ["product_id": productId])
        
        sendRequest(orderListRequest, shouldAuthenticate: true, shouldParseResponse: true, completion: completion)
    }
    
    func getOrderBook(productId: String, level: Int, completion: @escaping (_ error: ExchangeError?, _ response: OrderBook?) -> ()) {
        let orderBookRequest = request(relativePath: "/products/\(productId)/book", method: "GET", params: ["level": "\(level)"])
        
        sendRequest(orderBookRequest, shouldAuthenticate: false, shouldParseResponse: true, completion: completion)
    }
    
    func getCandles(productId: String, startTime: String, endTime: String, granularity: Int, completion: @escaping (_ error: ExchangeError?, _ response: CandleList?) -> ()) {
        let candlesRequest = request(relativePath: "/products/\(productId)/candles", method: "GET", params: ["start": "\(startTime)", "end": "\(endTime)", "granularity": "\(granularity)"])
        
        sendRequest(candlesRequest, shouldAuthenticate: false, shouldParseResponse: true, completion: completion)
    }
    
    func getFills(completion: @escaping (_ error: ExchangeError?, _ response: FillList?) -> ()) {
        let fillListRequest = request(relativePath: "/fills", method: "GET", params: nil)
        
        sendRequest(fillListRequest, shouldAuthenticate: true, shouldParseResponse: true, completion: completion)
    }
    
    func cancelOrder(orderId: String, completion: @escaping (_ error: ExchangeError?, _ response: ExchangeMessage?) -> ()) {
        let cancelOrderRequest = request(relativePath: "/orders/\(orderId)", method: "DELETE", params: nil)
        
        sendRequest(cancelOrderRequest, shouldAuthenticate: true, shouldParseResponse: false, completion: completion)
    }
    
    func cancelAllOpenOrders(productId: String, completion: @escaping (_ error: ExchangeError?, _ response: CancelledOrdersList?) -> ()) {
        let cancelAllOpenOrdersRequest = request(relativePath: "/orders", method: "DELETE", params: ["product_id": productId])
        
        sendRequest(cancelAllOpenOrdersRequest, shouldAuthenticate: true, shouldParseResponse: false, completion: completion)
    }
    
}

// MARK: - WebSocketDelegate methods

extension Exchange: WebSocketDelegate {
    
    func connectWebSocket() {
        exchangeWebSocket.delegate = self
        exchangeWebSocket.connect()
    }
    
    func disconnectWebSocket() {
        exchangeWebSocket.delegate = nil
        exchangeWebSocket.disconnect()
    }
    
    func websocketDidConnect(socket: WebSocket) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        
        let timestamp = dateFormatter.string(from: Date(timeIntervalSinceNow: 0.0))
        
        let subscribeMessage: [String: Any] = [
            "type": "subscribe",
            "product_ids": [
                "BTC-EUR",
                "BTC-GBP",
                "BTC-USD",
                "ETH-BTC",
                "ETH-EUR",
                "ETH-USD",
                "LTC-BTC",
                "LTC-EUR",
                "LTC-USD"
            ],
            "key": kExchangeAccessKey,
            "timestamp": String(timestamp),
            "passphrase": kExchangePassphrase,
            "signature": ""
        ]
        
        socket.write(string: createJSON(dictionary: subscribeMessage)) {
            
        }
        
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        
        guard error == nil else {
            print("WebSocket disconnected: \(error!.localizedDescription)")
            
            return
        }
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        guard let exchangeMessage = Mapper<ExchangeMessage>().map(JSONString: text) else {
            return
        }
        
        if exchangeMessage.type == "match" {
            priceUpdateDelegate?.didReceivePriceUpdate(productId: exchangeMessage.productId, price: exchangeMessage.price)
        }
            
        else if exchangeMessage.type == "open" {
            orderUpdateDelegate?.didReceiveOrder(orderId: exchangeMessage.orderId, productId: exchangeMessage.productId, type: exchangeMessage.type, side: exchangeMessage.side, price: exchangeMessage.price, size: exchangeMessage.size)
        }
            
        else if exchangeMessage.type == "done" {
            orderUpdateDelegate?.didCloseOrder(orderId: exchangeMessage.orderId, productId: exchangeMessage.productId, side: exchangeMessage.side)
        }
        
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("WebSocket received data: \(data)")
    }
    
    func websocketDidReceivePong(socket: WebSocket, data: Data?) {
        print("WebSocket received pong.")
    }
    
}

