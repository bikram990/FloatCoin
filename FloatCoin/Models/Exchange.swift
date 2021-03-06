//
//  Provider.swift
//  Jo
//
//  Created by Kaunteya Suryawanshi on 24/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation
enum Exchange: String, CaseIterable {
    case binance, bitfinex, cex, coinbase, kraken

    var description: String {
        switch self {
        case .binance: return "Binance"
        case .bitfinex: return "Bitfinex"
        case .cex: return "CEX"
        case .coinbase: return "Coinbase"
        case .kraken: return "Kraken"
        }
    }

    var type: ExchangeProtocol.Type {
        switch self {
        case .binance: return Binance.self
        case .bitfinex: return Bitfinex.self
        case .cex: return CEX.self
        case .coinbase: return Coinbase.self
        case .kraken: return Kraken.self
        }
    }
}

extension Exchange: Comparable {
    static func <(lhs: Exchange, rhs: Exchange) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
