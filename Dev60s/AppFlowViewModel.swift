//
//  AppFlowViewModel.swift
//  Dev60s
//
//  High-level MVVM state for normal app flow:
//  Landing -> Home (level + category) -> Quiz -> Result
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
    case home
    case quiz
    case result
}

final class AppFlowViewModel: ObservableObject {
    @Published var step: AppStep = .landing
    @Published var selectedLevel: QuizLevel?
    @Published var selectedCategory: QuizCategory?
    @Published var resultSummary: QuizResultSummary?
    @Published var quizViewModel: QuizQuestionViewModel?

    var canStartQuiz: Bool {
        selectedLevel != nil && selectedCategory != nil
    }

    func handleLandingGetStarted() {
        step = .home
    }

    func handleSelect(level: QuizLevel) {
        selectedLevel = level
    }

    func handleSelect(category: QuizCategory) {
        selectedCategory = category
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

    func handleBackToHome() {
        step = .home
    }

    func handleRestart() {
        selectedLevel = nil
        selectedCategory = nil
        resultSummary = nil
        quizViewModel = nil
        step = .landing
    }
}


