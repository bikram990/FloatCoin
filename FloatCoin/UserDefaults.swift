//
//  UserDefaults.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 26/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let keyFontSize = "fontSize"
    static let keyFloatOnTop = "floatOnTop"
    private static let keyUserExchange = "userKeys"
    static let keyInstallDate = "installDate"
    static let keyIsDark = "isDarkMode"
    static let keyTranslucent = "translucent"

    static let notificationPairDidAdd = NSNotification.Name(rawValue: "notificationPairDidAdd")
    static let notificationPairDidRemove = NSNotification.Name(rawValue: "notificationPairDidRemove")

    static var floatOnTop: Bool {
        get {
            return UserDefaults.standard.bool(forKey: keyFloatOnTop)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyFloatOnTop)
        }
    }

    static var isDarkMode: Bool {
        return UserDefaults.standard.bool(forKey: keyIsDark)
    }

    static var isTranslucent: Bool {
        return UserDefaults.standard.bool(forKey: keyTranslucent)
    }

    static var installDate: Date {
        return UserDefaults.standard.object(forKey: keyInstallDate) as! Date
    }

    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            keyFontSize: 12,
            keyFloatOnTop: true,
            keyIsDark: true,
            keyTranslucent: true
            ])
        UserDefaults.standard.setOnce(Date(), forKey: keyInstallDate)
    }
    
    class func add(exchange: Exchange, pair: Pair) {
        var dict = UserDefaults.standard.dictionary(forKey: keyUserExchange) as? [String: [String]] ?? [String: [String]]()

        var list = dict[exchange.rawValue] ?? [String]()
        assert(!list.contains(pair.joined(":")), "Pair already added")
        list.append(pair.joined(":"))
        dict[exchange.rawValue] = list.sorted()
        UserDefaults.standard.set(dict, forKey: keyUserExchange)

        NotificationCenter.default.post(name: notificationPairDidAdd, object: nil, userInfo: ["exchange" : exchange, "pair":pair])
    }

    class func remove(exchange: Exchange, pair: Pair) {
        var dict = UserDefaults.standard.dictionary(forKey: keyUserExchange) as! [String: [String]]
        let list = dict[exchange.rawValue]!.filter{ $0 != pair.joined(":") }
        dict[exchange.rawValue] = list.isEmpty ? nil : list//Remove key of list is empty
        UserDefaults.standard.set(dict, forKey: keyUserExchange)

        NotificationCenter.default.post(name: notificationPairDidRemove, object: nil, userInfo: ["exchange" : exchange, "pair":pair])
    }

    class var isExchangeListEmpty: Bool {
        if let dict = UserDefaults.standard.dictionary(forKey: keyUserExchange), dict.count > 0 {
            return false
        }
        return true
    }

    class func has(exchange: Exchange, pair: Pair) -> Bool {
        if let all = pairsForAllExchanges {
            return all.contains(where: { (aExchange, aPairList) -> Bool in
                return exchange == aExchange && aPairList.contains(pair)
            })
        }
        return false
    }

    class var pairsForAllExchanges: [Exchange: Set<Pair>]? {
        guard let dict = UserDefaults.standard.dictionary(forKey: keyUserExchange) as? [String: [String]]else {
            return nil
        }
        guard dict.isEmpty == false else { return nil }
        var newDict = [Exchange: Set<Pair>]()
        for (key, pairStringList) in dict {
            let exchange: Exchange = Exchange(rawValue: key)!
            let pairs:[Pair] = pairStringList.compactMap {
                let split = $0.split(separator: ":")
                if split.count != 2 { return nil }
                let a = Currency("\(split[0])")
                let b = Currency("\(split[1])")
                return Pair(a, b)
            }
            newDict[exchange] = Set(pairs)
        }
        return newDict
    }
}
