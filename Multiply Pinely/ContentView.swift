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
    @State private var questionNumber = 0
    @State private var pineTreeScore = 0
    @State private var playerAnswer = ""
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var showingScore = false
    @State private var settingGameRound = true
    @State private var gameRoundActive = false
    @FocusState private var answerFieldIsFocused: Bool
    
    var body: some View {
        VStack {
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
                Spacer()
                
                Section {
                    Text(gameRoundActive ? questionsList[questionNumber].text : "Select your settings above")
                        .font(gameRoundActive ? .largeTitle : .title2.weight(.heavy))
                        .foregroundColor(gameRoundActive ? .mint : .orange)
                    
                    TextField("Enter your answer", text: $playerAnswer)
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .keyboardType(.decimalPad)
                        .focused($answerFieldIsFocused)
                        .disabled(gameRoundActive ? false : true)
                } header: {
                    HStack {
                        Image(systemName: "x.squareroot")
                            .foregroundColor(.mint)
                        
                        Text("Calculate")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        
                        Image(systemName: "sum")
                            .foregroundColor(.mint)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 30) {
                    Text("Question \(questionNumber + 1) of \(numberOfQuestions)")
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
                    .background(gameRoundActive ? .gray : .mint)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .disabled(gameRoundActive ? true : false)
                }
                
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Cancel") {
                    answerFieldIsFocused = false
                }
                
                Spacer()
                
                Button("Submit") {
                    submitAnswer()
                }
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("""
                 \(scoreMessage)
                 You currently have \(pineTreeScore) 🌲 \(pineTreeScore <= 1 ? "tree" : "trees") to plant.
                 """)
        }
    }
    
    func generateQuestion() {
        let randomNumber = Int.random(in: 1...12)
        let question = Question(text: "\(randomNumber) x \(multiplyNumber)", answer: randomNumber * multiplyNumber)
        questionsList.append(question)
    }
    
    func askQuestion() {
        if questionNumber < numberOfQuestions {
            questionNumber += 1
            playerAnswer = ""
        }
    }
    
    func submitAnswer() {
        if Int(playerAnswer) == questionsList[questionNumber].answer {
            scoreTitle = "Correct ✅"
            scoreMessage = "Nicely done! You gained 1 🌲."
            numberOfCorrectAnswer += 1
            pineTreeScore += 1
        } else {
            scoreTitle = "Wrong ❌"
            scoreMessage = "The answer is \(questionsList[questionNumber].answer)."
        }
        
        showingScore = true
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
