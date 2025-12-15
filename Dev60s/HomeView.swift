//
//  HomeView.swift
//  Dev60s
//
//  Main home screen: level selection + category selection.
//

import SwiftUI

struct HomeView: View {
    let selectedLevel: QuizLevel?
    let selectedCategory: QuizCategory?
    let handleSelectLevel: (QuizLevel) -> Void
    let handleSelectCategory: (QuizCategory) -> Void
    let handleStartQuiz: () -> Void

    private var canStart: Bool {
        selectedLevel != nil && selectedCategory != nil
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.95, blue: 1.0),
                    Color(red: 0.93, green: 0.96, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                header

                levelSection

                categorySection

                Spacer()

                Button(action: {
                    if canStart {
                        handleStartQuiz()
                    }
                }) {
                    Text("Start Interview Prep")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.black.opacity(canStart ? 1.0 : 0.3))
                        )
                }
                .buttonStyle(.plain)
                .disabled(!canStart)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Dev 60s")
                .font(.system(size: 26, weight: .heavy))
            Text("Choose your level and topic.\nEach question is 60 seconds.")
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
        }
    }

    private var levelSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Level")
                .font(.system(size: 16, weight: .semibold))

            HStack(spacing: 12) {
                ForEach([QuizLevel.easy, .normal, .hard]) { level in
                    let isSelected = level == selectedLevel
                    Button {
                        handleSelectLevel(level)
                    } label: {
                        Text(level.rawValue)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(isSelected ? Color(red: 0.30, green: 0.21, blue: 0.70) : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(isSelected ? Color(red: 0.94, green: 0.91, blue: 1.0) : .white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(isSelected ? Color(red: 0.80, green: 0.74, blue: 1.0) : Color(.systemGray5), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Category")
                .font(.system(size: 16, weight: .semibold))

            let categories: [QuizCategory] = [
                .cs, .os, .network, .swift, .swiftUI, .uiKit, .mobile
            ]

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(categories) { category in
                    let isSelected = category == selectedCategory
                    Button {
                        handleSelectCategory(category)
                    } label: {
                        Text(category.rawValue)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(isSelected ? Color(red: 0.30, green: 0.21, blue: 0.70) : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(isSelected ? Color(red: 0.94, green: 0.91, blue: 1.0) : .white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(isSelected ? Color(red: 0.80, green: 0.74, blue: 1.0) : Color(.systemGray5), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    HomeView(
        selectedLevel: .easy,
        selectedCategory: .swift,
        handleSelectLevel: { _ in },
        handleSelectCategory: { _ in },
        handleStartQuiz: {}
    )
}


