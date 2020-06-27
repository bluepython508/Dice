//
//  ContentView.swift
//  Dice
//
//  Created by Ben on 6/22/20.
//  Copyright © 2020 Ben. All rights reserved.
//

import SwiftUI
import Introspect

extension View {

    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    /// ```
    /// Text("Label")
    ///     .isHidden(true)
    /// ```
    ///
    /// Example for complete removal:
    /// ```
    /// Text("Label")
    ///     .isHidden(true, remove: true)
    /// ```
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        modifier(HiddenModifier(isHidden: hidden, remove: remove))
    }
}

fileprivate struct HiddenModifier: ViewModifier {

    private let isHidden: Bool
    private let remove: Bool

    init(isHidden: Bool, remove: Bool = false) {
        self.isHidden = isHidden
        self.remove = remove
    }

    func body(content: Content) -> some View {
        Group {
            if isHidden {
                if remove {
                    EmptyView()
                } else {
                    content.hidden()
                }
            } else {
                content
            }
        }
    }
}

struct DiceRoll {
    let size: Int
    var roll: Int
}

struct ContentView: View {
    @State var rolls: [DiceRoll] = [DiceRoll]()
    
    @State var lastSize: Int? = nil
    
    @State var customRoll: String = ""
    
    @State var isCustomRollActive = false
    var body: some View {
        NavigationView {
            VStack {
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
                Button("Repeat Last (\(lastSize ?? 0))") { self.rollDice(self.lastSize ?? 0) }.padding(10).isHidden(lastSize == nil)
                NavigationLink(destination: rollCustomView(), isActive: $isCustomRollActive) {
                    Text("Roll Custom").padding(10)
                }
                Spacer()
            }
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
    
    func rollCustomView() -> some View {
        VStack {
            TextField<Text>("0", text: $customRoll).introspectTextField { textField in textField.becomeFirstResponder()}.keyboardType(.numberPad)
            Spacer()
        }.navigationBarTitle("Roll Custom", displayMode: .inline).navigationBarItems(
            leading: Button("Cancel", action: {
                self.isCustomRollActive = false
                self.customRoll = ""
            }).padding(10),
            trailing: Button("Roll", action: {
                self.isCustomRollActive = false
                if let toRoll = Int(self.customRoll) {
                    self.rollDice(toRoll)
                }
                self.customRoll = ""
            }).padding(10)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
