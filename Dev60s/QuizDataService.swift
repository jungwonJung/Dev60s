//
//  QuizDataService.swift
//  Dev60s
//
//  Service for loading quiz questions from JSON bundle file
//

import Foundation

// MARK: - JSON Data Models

struct QuizQuestionJSON: Codable {
    let id: String
    let category: String
    let baseDifficulty: String
    let targetLevel: String
    let questionText: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
}

// MARK: - Quiz Data Service

actor QuizDataCache {
    private var cachedQuestions: [QuizQuestion]?
    
    func getQuestions() -> [QuizQuestion]? {
        return cachedQuestions
    }
    
    func setQuestions(_ questions: [QuizQuestion]) {
        cachedQuestions = questions
    }
    
    func clear() {
        cachedQuestions = nil
    }
}

class QuizDataService {
    private static let cache = QuizDataCache()
    
    /// Load questions from JSON bundle file with optional filtering
    static func loadQuestions(
        category: QuizCategory? = nil,
        level: QuizLevel? = nil,
        count: Int? = nil
    ) async throws -> [QuizQuestion] {
        // Parse once, cache forever
        let cached = await cache.getQuestions()
        if cached == nil {
            let questions = try await parseQuestionsFromBundle()
            await cache.setQuestions(questions)
        }
        
        // Get cached questions
        guard var filtered = await cache.getQuestions() else {
            throw QuizDataError.parsingFailed
        }
        
        // Filter by category (with mapping from enum to JSON category names)
        if let category = category {
            let categoryNames = mapCategoryToJSONNames(category)
            filtered = filtered.filter { question in
                categoryNames.contains { name in
                    question.title.lowercased() == name.lowercased()
                }
            }
        }
        
        // Filter by level (targetLevel matches selected level)
        if let level = level {
            filtered = filtered.filter { question in
                guard let targetLevel = question.targetLevel else { return false }
                return targetLevel.lowercased() == level.rawValue.lowercased()
            }
        }
        
        // Shuffle for randomness (using system random seed)
        filtered = filtered.shuffled()
        
        // Limit count if specified
        if let count = count {
            filtered = Array(filtered.prefix(count))
        }
        
        // Update indices for display and shuffle options for each question
        return filtered.enumerated().map { index, question in
            // Shuffle options and update correctAnswerIndex
            let shuffledOptions = question.options.shuffled()
            let originalCorrectOption = question.options[question.correctAnswerIndex]
            let newCorrectAnswerIndex = shuffledOptions.firstIndex(where: { $0.text == originalCorrectOption.text }) ?? 0
            
            return QuizQuestion(
                id: question.id,
                title: question.title,
                index: index + 1,
                total: filtered.count,
                prompt: question.prompt,
                options: shuffledOptions, // ✅ Shuffled options
                correctAnswerIndex: newCorrectAnswerIndex, // ✅ Updated index
                explanation: question.explanation,
                targetLevel: question.targetLevel
            )
        }
    }
    
    /// Parse questions from bundle JSON file
    private static func parseQuestionsFromBundle() async throws -> [QuizQuestion] {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            throw QuizDataError.fileNotFound
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonQuestions = try decoder.decode([QuizQuestionJSON].self, from: data)
        
        // Convert JSON models to QuizQuestion
        return jsonQuestions.map { json in
            let options = json.options.map { QuizOption(text: $0) }
            return QuizQuestion(
                id: json.id,
                title: json.category,
                index: 0, // Will be set later when filtering
                total: 0,  // Will be set later when filtering
                prompt: json.questionText,
                options: options,
                correctAnswerIndex: json.correctAnswerIndex,
                explanation: json.explanation,
                targetLevel: json.targetLevel
            )
        }
    }
    
    /// Clear cache (useful for testing or updates)
    static func clearCache() async {
        await cache.clear()
    }
    
    /// Map QuizCategory enum to JSON category name(s)
    /// Returns array because some categories map to multiple JSON categories
    private static func mapCategoryToJSONNames(_ category: QuizCategory) -> [String] {
        switch category {
        case .cs:
            // CS category includes Computer Science, Algorithm, and Data Structure
            return ["Computer Science", "Algorithm", "Data Structure"]
        case .swift:
            return ["Swift"]
        case .mobile:
            return ["Mobile Dev"]
        case .swiftUI:
            return ["SwiftUI"]
        case .uiKit:
            return ["UIKit"]
        case .os:
            return ["OS"]
        case .network:
            return ["Network"]
        }
    }
    
}

enum QuizDataError: Error {
    case fileNotFound
    case parsingFailed
    case invalidData
    
    var localizedDescription: String {
        switch self {
        case .fileNotFound:
            return "Questions file not found in bundle"
        case .parsingFailed:
            return "Failed to parse questions data"
        case .invalidData:
            return "Invalid question data format"
        }
    }
}

