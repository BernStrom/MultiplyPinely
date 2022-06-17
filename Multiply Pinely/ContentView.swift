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

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.green)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
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
    @State private var endGame = false
    @State private var settingGameRound = true
    @State private var gameRoundActive = false
    @State private var resetGameProgress = false
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

                Text("Multiply {🌲} Pinely")
                    .titleStyle()
                
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
                        .disabled(settingGameRound || endGame ? true : false)
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
                        resetGameProgress.toggle()
                    } label: {
                        Text(settingGameRound ? "Reset Settings" : "Reset Game")
                    }
                    .padding()
                    .background(.orange)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .alert("Resetting Game...", isPresented: $resetGameProgress) {
                        Button("Yes", action: resetGame)
                        Button("No") { }
                    } message: {
                        Text(settingGameRound ? "Are you sure you want to reset your settings?" : "Are you sure you want to reset your progress?")
                    }
                    
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
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Cancel") {
                    answerFieldIsFocused.toggle()
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
        .alert(scoreTitle, isPresented: $endGame) {
            Button("Reset", action: resetGame)
            Button("OK") {
                playerAnswer = ""
            }
        } message: {
            Text("""
                You got \(numberOfCorrectAnswer) out of \(numberOfQuestions) correct.
                Tap Reset to start a new round.
                """)
        }
    }
    
    func generateQuestion() {
        let randomNumber = Int.random(in: 1...12)
        let question = Question(text: "\(randomNumber) x \(multiplyNumber)", answer: randomNumber * multiplyNumber)
        questionsList.append(question)
    }
    
    func askQuestion() {
        if questionNumber + 1 < numberOfQuestions {
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
        
        if questionNumber + 1 == numberOfQuestions {
            endGame = true
            scoreTitle = "Your Results 📋"
        }
        
        showingScore = true
    }
    
    func startGame() {
        settingGameRound = false
        gameRoundActive = true
    }
    
    func resetGame() {
        multiplyNumber = 2
        numberOfQuestions = 5
        numberOfCorrectAnswer = 0
        questionsList = [Question]()
        questionNumber = 0
        pineTreeScore = 0
        playerAnswer = ""
        showingScore = false
        settingGameRound = true
        gameRoundActive = false
        endGame = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
