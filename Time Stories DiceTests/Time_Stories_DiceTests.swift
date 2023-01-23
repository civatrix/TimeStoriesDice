//
//  Time_Stories_DiceTests.swift
//  Time Stories DiceTests
//
//  Created by DanielJohns on 2020-11-18.
//

import XCTest
@testable import Time_Stories_Dice

class Time_Stories_DiceTests: XCTestCase {

    func testOneDice() {
        let results = DiceProbability.probabilities(for: 1)
        XCTAssertEqual(results, [.init(outcome: 0, probability: 1.0/2.0),
                                 .init(outcome: 1, probability: 1.0/3.0),
                                 .init(outcome: 2, probability: 1.0/6.0)])
    }
    
    func testTwoDice() {
        let results = DiceProbability.probabilities(for: 2)
        XCTAssertEqual(results.stringified(), [CombinedResult(outcome: "0", probability: "25%"),
                                               CombinedResult(outcome: "1", probability: "33%"),
                                               CombinedResult(outcome: "2", probability: "28%"),
                                               CombinedResult(outcome: "3", probability: "11%"),
                                               CombinedResult(outcome: "4", probability: "3%")])
    }
    
    func testThreeDice() {
        let results = DiceProbability.probabilities(for: 3)
        XCTAssertEqual(results.stringified(), [CombinedResult(outcome: "0", probability: "12%"),
                                               CombinedResult(outcome: "1", probability: "25%"),
                                               CombinedResult(outcome: "2", probability: "29%"),
                                               CombinedResult(outcome: "3", probability: "20%"),
                                               CombinedResult(outcome: "4", probability: "10%"),
                                               CombinedResult(outcome: "5", probability: "3%"),
                                               CombinedResult(outcome: "6", probability: "<1%")])
    }
}
