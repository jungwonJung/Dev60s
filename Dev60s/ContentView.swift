//
//  ContentView.swift
//  Dev60s
//
//  Created by JungWonJung on 15/12/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appFlowViewModel = AppFlowViewModel()

    var body: some View {
        NavigationStack {
            Group {
                switch appFlowViewModel.step {
                case .landing:
                    LandingView {
                        appFlowViewModel.handleLandingGetStarted()
                    }

                case .home:
                    HomeView(
                        selectedLevel: appFlowViewModel.selectedLevel,
                        selectedCategory: appFlowViewModel.selectedCategory,
                        handleSelectLevel: { level in
                            appFlowViewModel.handleSelect(level: level)
                        },
                        handleSelectCategory: { category in
                            appFlowViewModel.handleSelect(category: category)
                        },
                        handleStartQuiz: {
                            appFlowViewModel.handleStartQuiz()
                        }
                    )

                case .quiz:
                    if let quizVM = appFlowViewModel.quizViewModel {
                        QuizQuestionView(
                            viewModel: quizVM,
                            handleCompleted: {
                                appFlowViewModel.handleFinishQuiz()
                            }
                        )
                    }

                case .result:
                    if let summary = appFlowViewModel.resultSummary {
                        QuizResultView(
                            summary: summary,
                            handleBackHome: {
                                appFlowViewModel.handleBackToHome()
                            }
                        )
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
