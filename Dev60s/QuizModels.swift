//
//  QuizModels.swift
//  Dev60s
//
//  Quiz data models with real Swift questions
//

import Foundation

struct QuizOption: Identifiable, Hashable {
    let id: UUID = UUID()
    let text: String
}

struct QuizQuestion: Identifiable, Hashable {
    let id: String               // Question ID from database
    let title: String            // Category name
    let index: Int               // 1-based index (for display)
    let total: Int               // total number of questions in quiz
    let prompt: String
    let options: [QuizOption]
    let correctAnswerIndex: Int // Index of correct answer in options array
    let explanation: String?    // Optional explanation
    let targetLevel: String?    // Target difficulty level (Easy, Normal, Hard)
}

struct QuizResultItem: Identifiable, Hashable {
    let id: UUID = UUID()
    let questionText: String
    let correctAnswer: String
    let userAnswer: String
    let explanation: String? // Explanation for the correct answer
}

struct QuizResultSummary {
    let correctCount: Int
    let totalCount: Int
    let incorrectItems: [QuizResultItem]
}

// MARK: - Mock Data (Preview Only)

enum QuizMockData {
    /// Empty result summary for SwiftUI previews only
    /// In production, use QuizQuestionViewModel.generateResultSummary()
    static let resultSummary: QuizResultSummary = QuizResultSummary(
        correctCount: 0,
        totalCount: 0,
        incorrectItems: []
    )
}
