//
//  ContentView.swift
//  Dice
//
//  Created by Ben on 6/22/20.
//  Copyright © 2020 Ben. All rights reserved.
//

import SwiftUI
import Foundation

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct DiceRoll {
    let size: Int
    var roll: Int
}

struct ContentView: View {
    @State var rolls: [DiceRoll] = [DiceRoll]()
    
    @State var lastSize: Int? = nil
    
    var body: some View {
        VStack() {
            Spacer()
            Text(rolls.map() { it in it.roll }.reduce(0, {acc, element in acc + element}).description)
            Text(rolls.map() { it in "\(it.roll) (\(it.size))" }.joined(separator: " + "))
            Button<Text>("Clear", action: { self.rolls.removeAll() }).padding(10)
            Button<Text>("Reroll All", action: { self.rolls = self.rolls.map { it in DiceRoll(size: it.size, roll: Int.random(in: 1...it.size)) } }).padding(10)
            Spacer()
            HStack() {
                VStack() {
                    Button<Text>(count(100) + "D100", action: { self.rollDice(100) }).padding(10)
                    Button<Text>(count(12) + "D12", action: { self.rollDice(12) }).padding(10)
                    Button<Text>(count(8) + "D8", action: { self.rollDice(8) }).padding(10)
                    Button<Text>(count(4) + "D4", action: { self.rollDice(4) }).padding(10)
                }.padding(5)
                VStack() {
                    Button<Text>(count(20) + "D20", action: { self.rollDice(20) }).padding(10)
                    Button<Text>(count(10) + "D10", action: { self.rollDice(10) }).padding(10)
                    Button<Text>(count(6) + "D6", action: { self.rollDice(6) }).padding(10)
                    Button<Text>(count(2) + "D2", action: { self.rollDice(2) }).padding(10)
                }.padding(5)
            }
            Button("Repeat Last") { if (self.lastSize != nil) { self.rollDice(self.lastSize ?? 0) } }
            
            Spacer()
        }
    }
    
    func rollDice(_ size: Int) {
        rolls.append(DiceRoll(size: size, roll: Int.random(in: 1...size)))
        lastSize = size
    }
    
    func count(_ size: Int) -> String {
        let amount = rolls.filter({it in it.size == size}).count
        if (amount > 0) {
            return "(\(amount)) "
        }
        return ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
