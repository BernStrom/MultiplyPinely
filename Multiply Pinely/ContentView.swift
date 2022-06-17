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
    @State private var numberOfCorrectAnswer = 0
    @State private var questionsList = [Question]()
    @State private var questionNumber = 1
    @State private var pineTreeScore = 0
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
                
            VStack(spacing: 20) {
                Spacer()
                Spacer()
                
                Section {
                    Text(gameRoundActive ? questionsList[0].text : "Select your settings above")
                        .font(gameRoundActive ? .largeTitle : .title2.weight(.heavy))
                        .foregroundColor(gameRoundActive ? .mint : .orange)
                } header: {
                    HStack {
                        Image(systemName: "x.squareroot")
                            .foregroundColor(.mint)
                        
                        Text("Calculate ")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        
                        Image(systemName: "sum")
                            .foregroundColor(.mint)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 30) {
                    Text("Question \(questionNumber) of \(numberOfQuestions)")
                        .font(.headline)
                    
                    HStack(spacing: 60) {
                        VStack(spacing: 10) {
                            Text("Correct Answer In:")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                            
                            Text("\(numberOfCorrectAnswer) out of \(numberOfQuestions) \(numberOfCorrectAnswer <= 1 ? "question" : "questions")")
                                .font(.headline)
                                .foregroundColor(numberOfCorrectAnswer == numberOfQuestions ? .green : .orange)
                        }
                        
                        VStack(spacing: 10) {
                            Text("🌲 Collected:")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                            
                            Text("\(pineTreeScore) \(pineTreeScore <= 1 ? "tree" : "trees")")
                                .font(.headline)
                                .foregroundColor(pineTreeScore == 0 ? .orange : .green)
                        }
                    }
                    
                    Text("Collect trees to plant them!  🌲 = 1 correct answer")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                HStack {
                    Button {
                        for _ in 0..<numberOfQuestions {
                            generateQuestion()
                        }
                        
                        startGame()
                    } label: {
                        Text("Start Game")
                    }
                    .padding()
                    .background(.mint)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    func generateQuestion() {
        let randomNumber = Int.random(in: 1...12)
        let question = Question(text: "\(randomNumber) x \(multiplyNumber)", answer: randomNumber * multiplyNumber)
        questionsList.append(question)
    }
    
    func startGame() {
        settingGameRound = false
        gameRoundActive = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
