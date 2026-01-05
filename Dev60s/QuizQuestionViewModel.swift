//
//  QuizQuestionViewModel.swift
//  Dev60s
//
//  MVVM ViewModel for quiz question screen with answer evaluation and timer
//

import Foundation
import Combine
import UIKit

enum AnswerState: Equatable {
    case none
    case selected
    case correct
    case incorrect
    
    // Explicit nonisolated Equatable conformance to avoid actor isolation warnings
    nonisolated static func == (lhs: AnswerState, rhs: AnswerState) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none), (.selected, .selected), (.correct, .correct), (.incorrect, .incorrect):
            return true
        default:
            return false
        }
    }
}

struct QuizAnswer {
    let question: QuizQuestion
    let selectedOption: QuizOption
    let isCorrect: Bool
    let correctOption: QuizOption
}

final class QuizQuestionViewModel: ObservableObject {
    @Published private(set) var questions: [QuizQuestion]
    @Published private(set) var currentIndex: Int = 0
    @Published var selectedOption: QuizOption?
    @Published var answerState: AnswerState = .none
    @Published var timeRemaining: Int = 60
    @Published var showCorrectAnswer: Bool = false
    @Published var autoAdvanceProgress: Double = 0.0
    
    let enableHapticFeedback: Bool
    let enableStrictTimer: Bool
    
    private var timer: Timer?
    private var autoAdvanceTimer: Timer?
    private var answers: [QuizAnswer] = []
    
    var currentQuestion: QuizQuestion? {
        guard questions.indices.contains(currentIndex) else { return nil }
        return questions[currentIndex]
    }
    
    var progressFraction: Double {
        guard let question = currentQuestion, question.total > 0 else { return 0 }
        return Double(question.index) / Double(question.total)
    }
    
    var isNextDisabled: Bool {
        answerState == .none
    }
    
    var buttonText: String {
        if answerState == .incorrect {
            return "Got it"
        } else {
            return "Next"
        }
    }
    
    var canEvaluate: Bool {
        answerState == .selected
    }
    
    var isLastQuestion: Bool {
        currentIndex >= questions.count - 1
    }
    
    init(questions: [QuizQuestion] = [], enableHapticFeedback: Bool = true, enableStrictTimer: Bool = true) {
        self.questions = questions
        self.enableHapticFeedback = enableHapticFeedback
        self.enableStrictTimer = enableStrictTimer
        startTimer()
    }
    
    func handleSelect(option: QuizOption) {
        // Allow selection change before evaluation (before Next is clicked)
        // Once evaluation starts (correct/incorrect), selection is frozen
        guard answerState == .none || answerState == .selected else { return }
        
        selectedOption = option
        answerState = .selected
    }
    
    func evaluateAnswer() {
        guard canEvaluate, let option = selectedOption, let question = currentQuestion else { return }
        
        // Stop timer
        timer?.invalidate()
        
        // Determine correct answer using correctAnswerIndex
        let correctOption = question.options.indices.contains(question.correctAnswerIndex) 
            ? question.options[question.correctAnswerIndex] 
            : question.options.first!
        let isCorrect = option == correctOption
        
        // Store answer
        answers.append(QuizAnswer(
            question: question,
            selectedOption: option,
            isCorrect: isCorrect,
            correctOption: correctOption
        ))
        
        if isCorrect {
            answerState = .correct
            showCorrectAnswer = true
            
            if enableHapticFeedback {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
            }
            
            // Auto-advance after 1 second with progress indicator
            if !isLastQuestion {
                // Not last question - auto-advance to next
                startAutoAdvance()
            }
            // If last question, navigation handled by parent view
        } else {
            answerState = .incorrect
            showCorrectAnswer = true
            
            if enableHapticFeedback {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.error)
            }
        }
    }
    
    private func startAutoAdvance() {
        autoAdvanceProgress = 0.0
        let duration: TimeInterval = 1.0
        let steps: Int = 20
        let interval = duration / Double(steps)
        
        autoAdvanceTimer?.invalidate()
        autoAdvanceTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            self.autoAdvanceProgress += 1.0 / Double(steps)
            
            if self.autoAdvanceProgress >= 1.0 {
                timer.invalidate()
                self.autoAdvanceProgress = 0.0
                self.handleNext()
            }
        }
    }
    
    func handleNext() {
        // For incorrect answers, user must click "Got it" to proceed
        guard answerState == .correct || answerState == .incorrect else { return }
        
        // Cancel auto-advance if still running
        autoAdvanceTimer?.invalidate()
        autoAdvanceProgress = 0.0
        
        // Check if this is the last question
        if isLastQuestion {
            // Don't reset state - let parent handle navigation to result
            return
        }
        
        // Reset state for next question
        selectedOption = nil
        answerState = .none
        showCorrectAnswer = false
        timeRemaining = 60
        
        // Stop current timer
        timer?.invalidate()
        
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            startTimer()
        }
    }
    
    func generateResultSummary() -> QuizResultSummary {
        let correctCount = answers.filter { $0.isCorrect }.count
        let totalCount = questions.count
        
        let incorrectItems = answers
            .filter { !$0.isCorrect }
            .map { answer in
                QuizResultItem(
                    questionText: answer.question.prompt,
                    correctAnswer: answer.correctOption.text,
                    userAnswer: answer.selectedOption.text,
                    explanation: answer.question.explanation
                )
            }
        
        return QuizResultSummary(
            correctCount: correctCount,
            totalCount: totalCount,
            incorrectItems: incorrectItems
        )
    }
    
    private func startTimer() {
        guard enableStrictTimer else { return }
        
        timer?.invalidate()
        timeRemaining = 60
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                // Timer finished - treat as incorrect
                self.timer?.invalidate()
                if self.answerState == .none || self.answerState == .selected, let question = self.currentQuestion {
                    // Store incorrect answer due to timeout
                    let correctOption = question.options.indices.contains(question.correctAnswerIndex) 
                        ? question.options[question.correctAnswerIndex] 
                        : question.options.first!
                    let selectedOption = self.selectedOption ?? QuizOption(text: "Time's Up")
                    
                    self.answers.append(QuizAnswer(
                        question: question,
                        selectedOption: selectedOption,
                        isCorrect: false,
                        correctOption: correctOption
                    ))
                    
                    // Show correct answer
                    self.showCorrectAnswer = true
                    self.answerState = .incorrect
                    
                    if self.enableHapticFeedback {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.error)
                    }
                    
                    // Auto-advance to next question after showing correct answer (2 seconds delay)
                    if !self.isLastQuestion {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.handleNext()
                        }
                    }
                }
            }
        }
    }
    
    deinit {
        timer?.invalidate()
        autoAdvanceTimer?.invalidate()
    }
}
