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
                        withAnimation(.easeInOut(duration: 0.4)) {
                            appFlowViewModel.handleLandingGetStarted()
                        }
                    }
                    .transition(.scale.combined(with: .opacity))

                case .categorySelection:
                    CategorySelectionView(
                        selectedCategory: appFlowViewModel.selectedCategory,
                        handleSelectCategory: { category in
                            appFlowViewModel.handleSelect(category: category)
                        },
                        handleNext: {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                appFlowViewModel.handleCategorySelected()
                            }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))

                case .quizSetup:
                    QuizSetupView(
                        selectedLevel: appFlowViewModel.selectedLevel,
                        selectedQuestionCount: appFlowViewModel.selectedQuestionCount,
                        enableHapticFeedback: appFlowViewModel.enableHapticFeedback,
                        enableStrictTimer: appFlowViewModel.enableStrictTimer,
                        handleSelectLevel: { level in
                            appFlowViewModel.handleSelect(level: level)
                        },
                        handleSelectQuestionCount: { count in
                            appFlowViewModel.handleSelectQuestionCount(count)
                        },
                        handleHapticFeedbackChanged: { value in
                            appFlowViewModel.enableHapticFeedback = value
                        },
                        handleStrictTimerChanged: { value in
                            appFlowViewModel.enableStrictTimer = value
                        },
                        handleStartQuiz: {
                            appFlowViewModel.handleStartQuiz()
                        },
                        handleBack: {
                            appFlowViewModel.handleBackToCategorySelection()
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
                            handleTryAgain: {
                                appFlowViewModel.handleTryAgain()
                            },
                            handleBackHome: {
                                appFlowViewModel.handleBackToCategorySelection()
                            }
                        )
                        .transition(.scale.combined(with: .opacity))
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
