//
//  ContentView.swift
//  Multiply Pinely
//
//  Created by Bern N on 6/14/22.
//

import SwiftUI

struct Question {
    var text: String
    var answer: Int
}

struct ContentView: View {
    @State private var multiplyNumber = 2
    @State private var numberOfQuestions = 5
    @State private var questionsList = [Question]()
    @State private var settingGameRound = true
    @State private var gameRoundActive = false
    
    var body: some View {
        ZStack {
            List {
                Section("Select Your Multiplication Table") {
                    Stepper(" Table of \(multiplyNumber)", value: $multiplyNumber, in: 2...12, step: 1)
                }
                
                Section("Desired Number of Questions (Max. 20)") {
                    Stepper("\(numberOfQuestions)", value: $numberOfQuestions, in: 5...20, step: 5)
                }
            }
            .disabled(settingGameRound ? false : true)
                
            VStack {
                Section {
                    Text(gameRoundActive ? questionsList[0].text : "")
                }
            }
            
            HStack {
                Button {
                    for _ in 0..<numberOfQuestions {
                        generateQuestion()
                    }
                } label: {
                    Text("Start Game")
                }
                .padding()
                .background(.mint)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
    }
    
    func generateQuestion() {
        let randomNumber = Int.random(in: 1...12)
        let question = Question(text: "What is \(randomNumber) x \(multiplyNumber)", answer: randomNumber * multiplyNumber)
        questionsList.append(question)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
