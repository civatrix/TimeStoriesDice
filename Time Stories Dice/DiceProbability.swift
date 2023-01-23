//
//  DiceProbability.swift
//  Time Stories Dice
//
//  Created by DanielJohns on 2020-11-18.
//

import Foundation

struct RollResult: Equatable, Comparable {
    static func < (lhs: RollResult, rhs: RollResult) -> Bool {
        lhs.outcome < rhs.outcome
    }
    
    let outcome: Int
    let probability: Double
    
    static let singleDice: [RollResult] = [.init(outcome: 0, probability: 1.0/2.0), .init(outcome: 1, probability: 1.0/3.0), .init(outcome: 2, probability: 1.0/6.0)]
}

struct CombinedResult: Equatable {
    let outcome: String
    let probability: String
}

extension Array where Element == RollResult {
    func combined(with: [RollResult]) -> [RollResult] {
        var newResult: [RollResult] = []
        
        forEach { outer in
            with.forEach { inner in
                newResult.append(.init(outcome: outer.outcome + inner.outcome, probability: outer.probability * inner.probability))
            }
        }
        return Set(newResult.map { $0.outcome }).map { outcome in
            RollResult(outcome: outcome, probability: newResult.filter { $0.outcome == outcome }.map { $0.probability }.reduce(0, +))
        }
    }
    
    func stringified() -> [CombinedResult] {
        sorted()
            .map {
                var probability = NumberFormatter.percent.string(from: NSNumber(value: $0.probability)) ?? "-"
                if probability == "0%" {
                    probability = "<1%"
                }
                
                return CombinedResult(outcome: "\($0.outcome)", probability: probability)
            }
    }
}

extension NumberFormatter {
    static let percent = { () -> NumberFormatter in
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        
        return formatter
    }()
    
    static let damage = { () -> NumberFormatter in
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter
    }()
}

struct DiceProbability {
    static func probabilities(for numberOfDice: Int) -> [RollResult] {
        guard numberOfDice > 1 else { return [] }
        
        return [[RollResult]](repeating: RollResult.singleDice, count: numberOfDice - 1).reduce(RollResult.singleDice) { $0.combined(with: $1) }
    }
}
