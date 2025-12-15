//
//  QuizQuestionViewModel.swift
//  Dev60s
//
//  Simple MVVM ViewModel focusing on UI state for the quiz question screen.
//

import Foundation
import Combine

final class QuizQuestionViewModel: ObservableObject {
    @Published private(set) var questions: [QuizQuestion]
    @Published private(set) var currentIndex: Int = 0
    @Published var selectedOption: QuizOption?

    var currentQuestion: QuizQuestion? {
        guard questions.indices.contains(currentIndex) else { return nil }
        return questions[currentIndex]
    }

    var progressFraction: Double {
        guard let question = currentQuestion, question.total > 0 else { return 0 }
        return Double(question.index) / Double(question.total)
    }

    var isNextDisabled: Bool {
        selectedOption == nil
    }

    init(questions: [QuizQuestion] = QuizMockData.questions) {
        self.questions = questions
    }

    func handleSelect(option: QuizOption) {
        selectedOption = option
    }

    func handleNext() {
        guard !isNextDisabled else { return }

        selectedOption = nil

        if currentIndex < questions.count - 1 {
            currentIndex += 1
        }
        // Navigation to result screen will be handled by the parent view.
    }
}


