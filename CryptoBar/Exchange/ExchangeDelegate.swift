//
//  Cryptoable.swift
//  Jo
//
//  Created by Kaunteya Suryawanshi on 24/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
protocol ExchangeDelegate {
    static var name: Exchange {get}
    static func urlRequest(for: [Pair]) -> URLRequest
    static func baseCryptoCurriencies() -> [Currency]
    static func FIATCurriences(crypto: Currency) -> [Currency]
    static func fetchRate(_ pairs: [Pair], completion: @escaping ([Pair:Double])-> Void)
}
