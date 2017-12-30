//
//  PairVC.swift
//  FloatCoin
//
//  Created by Kaunteya Suryawanshi on 25/12/17.
//  Copyright © 2017 Kaunteya Suryawanshi. All rights reserved.
//

import AppKit

class PairVC: NSViewController {

    var list: [UserExchangePair] = [
        UserExchangePair(exchange: .coinbase, pair: Pair("BTC:USD")),
        UserExchangePair(exchange: .cex, pair: Pair("BTC:USD")),
    ]

    @IBOutlet weak var exchangePopupButton: NSPopUpButton!
    @IBOutlet weak var basePopupButton: NSPopUpButton!
    @IBOutlet weak var fiatPopUpButton: NSPopUpButton!

    var selectedExchange: Exchange {
        return Exchange.all[exchangePopupButton.indexOfSelectedItem]
    }

    var selectedBase: Currency {
        assert( basePopupButton.indexOfSelectedItem >= 0)
        return selectedExchange.type.baseCryptoCurriencies()[basePopupButton.indexOfSelectedItem]
    }

    var selectedFIAT: Currency {
        assert(fiatPopUpButton.indexOfSelectedItem >= 0)
        return selectedExchange.type.FIATCurriences(crypto: selectedBase)[fiatPopUpButton.indexOfSelectedItem]
    }

    var selectedUserExchangePair: UserExchangePair {
        return UserExchangePair(
            exchange: selectedExchange,
            pair: Pair(a: selectedBase, b: selectedFIAT)
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Exchange.all.forEach { (ex) in
            exchangePopupButton.addItem(withTitle: ex.description)
        }
        exchangePopupButton.selectItem(at: 1)
        actionExchangeSelected(nil)
    }

    @IBAction func actionExchangeSelected(_ sender: NSPopUpButton?) {
        let baseCurriencies = selectedExchange.type.baseCryptoCurriencies()
        basePopupButton.removeAllItems()
        baseCurriencies.forEach {
            basePopupButton.addItem(withTitle: $0.stringValue)
        }
        basePopupButton.selectItem(at: 0)
        let fiatList = selectedExchange.type.FIATCurriences(crypto: baseCurriencies.first!)
        fiatPopUpButton.removeAllItems()
        fiatList.forEach {
            fiatPopUpButton.addItem(withTitle: $0.stringValue)
        }
    }

    @IBAction func actionBaseCurrencySelected(_ sender: NSPopUpButton) {
        fiatPopUpButton.removeAllItems()
        let fiatList = selectedExchange.type.FIATCurriences(crypto: selectedBase)
        fiatList.forEach {
            fiatPopUpButton.addItem(withTitle: $0.stringValue)
        }
    }

    @IBAction func add(_ sender: Any) {
        guard !UserDefaults.userExchangePairList.contains(selectedUserExchangePair) else {
            Swift.print("Alrady contains \(selectedUserExchangePair)");
            return
        }
        UserDefaults.add(exchange: selectedExchange, pair: Pair(a: selectedBase, b: selectedFIAT))
        self.dismiss(sender)
    }
}

