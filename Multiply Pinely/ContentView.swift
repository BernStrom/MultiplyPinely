//
//  ContentView.swift
//  Multiply Pinely
//
//  Created by Bern N on 6/14/22.
//

import SwiftUI

struct ContentView: View {
    @State private var multiplyNumber = 2
    @State private var numberOfQuestions = 5
    @State private var settingGameRound = true
    @State private var gameRoundActive = false
    
    var body: some View {
        List {
            Section("Select Your Multiplication Table") {
                Stepper(" Table of \(multiplyNumber)", value: $multiplyNumber, in: 2...12, step: 1)
            }
            
            Section("Desired Number of Questions (Max. 20)") {
                Stepper("\(numberOfQuestions)", value: $numberOfQuestions, in: 5...20, step: 5)
            }
        }
        .disabled(settingGameRound ? false : true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
