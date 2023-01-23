//
//  ContentView.swift
//  Time Stories Dice
//
//  Created by DanielJohns on 2020-11-18.
//

import SwiftUI

struct ContentView: View {
    // Input
    @State var numberOfDice = ""
    @State var plusOne = false
    @State var threshold = ""
    
    // Output
    @State var chanceToSucceed = ""
    @State var expectedDamage = ""
    @State var results: [CombinedResult] = []
    
    var body: some View {
        VStack {
            HStack {
                Text("Number of dice:")
                Spacer()
                TextField("", text: $numberOfDice)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 30)
            }
            Toggle("+1 on hit:", isOn: $plusOne)
            HStack {
                Text("Target:")
                Spacer()
                TextField("", text: $threshold)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 30)
            }
            Button("Calculate") {
                var probabilities = DiceProbability.probabilities(for: Int(numberOfDice) ?? 0)
                if plusOne {
                    probabilities = probabilities.map { $0.outcome == 0 ? $0 : .init(outcome: $0.outcome + 1, probability: $0.probability) }
                }
                
                if let threshold = Int(threshold) {
                    let chance = NumberFormatter.percent.string(from: NSNumber(value: probabilities.filter { $0.outcome >= threshold }.map { $0.probability }.reduce(0, +))) ?? "-"
                    chanceToSucceed = "Chance to get \(threshold) or higher: \(chance)"
                } else {
                    let combinedDamage = probabilities.reduce(0) { $0 + Double($1.outcome) * $1.probability }
                    expectedDamage = NumberFormatter.damage.string(from: NSNumber(value: combinedDamage)) ?? "-"
                    results = probabilities.stringified()
                    chanceToSucceed = ""
                }
            }
            Spacer()
            if !chanceToSucceed.isEmpty {
                Text(chanceToSucceed)
            } else if !results.isEmpty {
                Text("Expected damage: \(expectedDamage)")
                ForEach(results, id: \.outcome) { result in
                    HStack {
                        Text(result.outcome)
                        Spacer()
                        Text(result.probability)
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
