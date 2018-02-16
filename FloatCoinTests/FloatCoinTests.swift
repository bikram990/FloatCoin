//
//  FloatCoinTests.swift
//  FloatCoinTests
//
//  Created by Kaunteya Suryawanshi on 16/01/18.
//  Copyright © 2018 Kaunteya Suryawanshi. All rights reserved.
//

import XCTest

protocol ExchangeTests {
    var testPairs: [Pair] {get}
    func testURLGenerationForOnePair()
    func testURLGenerationForMultiplePairs()
    func testPriceRequest()
}

class FloatCoinTests: XCTestCase {
    let defaults = UserDefaults.standard

    let testKey = "testSetOnce"

    override func tearDown() {
        defaults.removeObject(forKey: testKey)
    }

    func testUserDefaultsSetOnce() {
        defaults.setOnce(1, forKey: testKey)
        XCTAssertEqual(defaults.integer(forKey: testKey), 1)
        defaults.setOnce(10, forKey: testKey)
        XCTAssertEqual(defaults.integer(forKey: testKey), 1)
    }

    func testAsd() {
        XCTAssertNil(Pair("ABC:USD:ASD"))
    }
}
