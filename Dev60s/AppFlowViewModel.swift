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
    @Published var selectedQuestionCount: Int = 10
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
        quizViewModel = QuizQuestionViewModel(questions: QuizMockData.questions)
        step = .quiz
    }

    func handleFinishQuiz() {
        // For now, use mock result summary; later compute from answers.
        resultSummary = QuizMockData.resultSummary
        step = .result
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
        selectedQuestionCount = 10
        resultSummary = nil
        quizViewModel = nil
        step = .landing
    }
}
