//
//  AppFlowViewModel.swift
//  Dev60s
//
//  High-level MVVM state for normal app flow:
//  Landing -> Category Selection -> Quiz Setup (Level + Count) -> Quiz -> Result
//

import Foundation
import Combine

enum QuizLevel: String, CaseIterable, Identifiable {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"

    var id: String { rawValue }
}

enum QuizCategory: String, CaseIterable, Identifiable {
    case cs = "CS"
    case os = "OS"
    case network = "Network"
    case swift = "Swift"
    case swiftUI = "SwiftUI"
    case uiKit = "UIKit"
    case mobile = "Mobile"

    var id: String { rawValue }
}

enum AppStep {
    case landing
    case categorySelection
    case quizSetup
    case quiz
    case result
}

final class AppFlowViewModel: ObservableObject {
    @Published var step: AppStep = .landing
    @Published var selectedLevel: QuizLevel?
    @Published var selectedCategory: QuizCategory?
    @Published var selectedQuestionCount: Int = 20
    @Published var enableHapticFeedback: Bool = true
    @Published var enableStrictTimer: Bool = true
    @Published var resultSummary: QuizResultSummary?
    @Published var quizViewModel: QuizQuestionViewModel?

    var canProceedToSetup: Bool {
        selectedCategory != nil
    }

    var canStartQuiz: Bool {
        selectedLevel != nil && selectedCategory != nil
    }

    func handleLandingGetStarted() {
        step = .categorySelection
    }

    func handleCategorySelected() {
        guard canProceedToSetup else { return }
        step = .quizSetup
    }

    func handleSelect(level: QuizLevel) {
        selectedLevel = level
    }

    func handleSelect(category: QuizCategory) {
        selectedCategory = category
    }

    func handleSelectQuestionCount(_ count: Int) {
        selectedQuestionCount = count
    }

    func handleStartQuiz() {
        guard canStartQuiz else { return }
        
        // Load questions from JSON asynchronously
        Task {
            do {
                let questions = try await QuizDataService.loadQuestions(
                    category: selectedCategory,
                    level: selectedLevel,
                    count: selectedQuestionCount
                )
                
                await MainActor.run {
                    quizViewModel = QuizQuestionViewModel(
                        questions: questions,
                        enableHapticFeedback: enableHapticFeedback,
                        enableStrictTimer: enableStrictTimer
                    )
                    step = .quiz
                }
            } catch {
                await MainActor.run {
                    // Handle error - for now, fallback to empty array
                    // In production, show error alert to user
                    print("Error loading questions: \(error.localizedDescription)")
                    quizViewModel = QuizQuestionViewModel(
                        questions: [],
                        enableHapticFeedback: enableHapticFeedback,
                        enableStrictTimer: enableStrictTimer
                    )
                    step = .quiz
                }
            }
        }
    }

    func handleFinishQuiz() {
        // Generate result summary from actual quiz answers
        guard let quizVM = quizViewModel else {
            // This should never happen in normal flow, but handle gracefully
            resultSummary = QuizResultSummary(correctCount: 0, totalCount: 0, incorrectItems: [])
            step = .result
            return
        }
        resultSummary = quizVM.generateResultSummary()
        step = .result
    }
    
    func handleTryAgain() {
        // Reset quiz state but keep category and settings
        // Create a fresh quiz view model with all states reset
        Task {
            do {
                let questions = try await QuizDataService.loadQuestions(
                    category: selectedCategory,
                    level: selectedLevel,
                    count: selectedQuestionCount
                )
                
                await MainActor.run {
                    quizViewModel = QuizQuestionViewModel(
                        questions: questions,
                        enableHapticFeedback: enableHapticFeedback,
                        enableStrictTimer: enableStrictTimer
                    )
                    resultSummary = nil
                    step = .quiz
                }
            } catch {
                await MainActor.run {
                    print("Error loading questions: \(error.localizedDescription)")
                    quizViewModel = QuizQuestionViewModel(
                        questions: [],
                        enableHapticFeedback: enableHapticFeedback,
                        enableStrictTimer: enableStrictTimer
                    )
                    resultSummary = nil
                    step = .quiz
                }
            }
        }
    }

    func handleBackToCategorySelection() {
        step = .categorySelection
    }

    func handleBackToQuizSetup() {
        step = .quizSetup
    }

    func handleRestart() {
        selectedLevel = nil
        selectedCategory = nil
        selectedQuestionCount = 20
        enableHapticFeedback = true
        enableStrictTimer = true
        resultSummary = nil
        quizViewModel = nil
        step = .landing
    }
}
