//
//  QuizModels.swift
//  Dev60s
//
//  Simple quiz models using mock data only.
//

import Foundation

struct QuizOption: Identifiable, Hashable {
    let id: UUID = UUID()
    let text: String
}

struct QuizQuestion: Identifiable, Hashable {
    let id: UUID = UUID()
    let title: String            // e.g. "Aptitude Test"
    let index: Int               // 1-based index
    let total: Int               // total number of questions in quiz
    let prompt: String
    let options: [QuizOption]
}

struct QuizResultItem: Identifiable, Hashable {
    let id: UUID = UUID()
    let questionText: String
    let correctAnswer: String
    let userAnswer: String
}

struct QuizResultSummary {
    let correctCount: Int
    let totalCount: Int
    let incorrectItems: [QuizResultItem]
}

// MARK: - Mock Data

enum QuizMockData {
    static let questions: [QuizQuestion] = [
        QuizQuestion(
            title: "Aptitude Test",
            index: 1,
            total: 2,
            prompt: "If a car travels 200 miles in 4 hours, what is its average speed?",
            options: [
                QuizOption(text: "40 Mph"),
                QuizOption(text: "50 Mph"),
                QuizOption(text: "60 Mph"),
                QuizOption(text: "70 Mph")
            ]
        ),
        QuizQuestion(
            title: "Logical Reasoning",
            index: 2,
            total: 2,
            prompt: "Mary is three times as old as John. If Mary is 30 years old, how old is John?",
            options: [
                QuizOption(text: "10 Years Old"),
                QuizOption(text: "15 Years Old"),
                QuizOption(text: "20 Years Old"),
                QuizOption(text: "30 Years Old")
            ]
        )
    ]

    static let resultSummary: QuizResultSummary = {
        let items: [QuizResultItem] = [
            QuizResultItem(
                questionText: "If a car travels 200 miles in 4 hours, what is its average speed?",
                correctAnswer: "50 Mph",
                userAnswer: "40 Mph"
            ),
            QuizResultItem(
                questionText: "What approach do you use to adapt a collection of elements that don’t conform to Identifiable?",
                correctAnswer: "Passing a key path along with the data",
                userAnswer: "Calling map(_:) on the data"
            )
        ]

        return QuizResultSummary(
            correctCount: 7,
            totalCount: 10,
            incorrectItems: items
        )
    }()
}


