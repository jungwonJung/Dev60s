//
//  CategorySelectionView.swift
//  Dev60s
//
//  Step 1: Category Selection Screen
//

import SwiftUI
import UIKit

// MARK: - Bento Grid Category Model

struct BentoCategory: Identifiable {
    let id: String
    let displayName: String
    let icon: String
    let quizCategory: QuizCategory
    let gradientColors: [Color]
    let borderColor: Color
}

// MARK: - Category Data

extension BentoCategory {
    static let categories: [BentoCategory] = [
        BentoCategory(
            id: "cs",
            displayName: "Computer Science",
            icon: "cpu.fill",
            quizCategory: .cs,
            gradientColors: [
                Color(red: 0.17, green: 0.24, blue: 0.31), // Deep Navy
                Color(red: 0.35, green: 0.41, blue: 0.48)  // Slate Blue
            ],
            borderColor: Color(red: 0.45, green: 0.51, blue: 0.58)
        ),
        BentoCategory(
            id: "swift",
            displayName: "Swift",
            icon: "chevron.left.forwardslash.chevron.right",
            quizCategory: .swift,
            gradientColors: [
                Color(red: 0.90, green: 0.49, blue: 0.13), // Burnt Orange
                Color(red: 0.58, green: 0.24, blue: 0.16)  // Dark Maroon
            ],
            borderColor: Color(red: 0.95, green: 0.60, blue: 0.25)
        ),
        BentoCategory(
            id: "mobile",
            displayName: "Mobile Dev",
            icon: "iphone",
            quizCategory: .mobile,
            gradientColors: [
                Color(red: 0.15, green: 0.68, blue: 0.38), // Forest Green
                Color(red: 0.11, green: 0.38, blue: 0.35)  // Dark Teal
            ],
            borderColor: Color(red: 0.20, green: 0.75, blue: 0.45)
        ),
        BentoCategory(
            id: "algorithm",
            displayName: "Algorithm",
            icon: "chart.bar.xaxis",
            quizCategory: .cs, // Mapping to CS for quiz logic
            gradientColors: [
                Color(red: 0.56, green: 0.27, blue: 0.68), // Royal Purple
                Color(red: 0.36, green: 0.25, blue: 0.75)  // Indigo
            ],
            borderColor: Color(red: 0.65, green: 0.35, blue: 0.78)
        ),
        BentoCategory(
            id: "datastructure",
            displayName: "Data Structure",
            icon: "square.stack.3d.up.fill",
            quizCategory: .cs, // Mapping to CS for quiz logic
            gradientColors: [
                Color(red: 0.75, green: 0.22, blue: 0.17), // Crimson Red
                Color(red: 0.50, green: 0.20, blue: 0.15)  // Deep Chocolate
            ],
            borderColor: Color(red: 0.85, green: 0.32, blue: 0.27)
        )
    ]
}

// MARK: - Bento Category Card

struct BentoCategoryCard: View {
    let category: BentoCategory
    let isSelected: Bool
    let hasAnySelection: Bool
    let isFullWidth: Bool
    let action: () -> Void
    @State private var isVisible = false
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            action()
        }) {
            ZStack {
                // Base translucent background
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground).opacity(0.8))
                
                // Gradient overlay
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: category.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(hasAnySelection && !isSelected ? 0.3 : 1.0)
                    .saturation(hasAnySelection && !isSelected ? 0.0 : 1.0) // Grayscale only when unselected AND something is selected
                
                // Border with enhanced thickness for selected
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(
                        isSelected ? category.borderColor : category.borderColor.opacity(hasAnySelection ? 0.3 : 0.5),
                        lineWidth: isSelected ? 2.0 : 0.5
                    )
                
                // Content with text at top-left and icon at bottom-right
                VStack(alignment: .leading, spacing: 0) {
                    // Text at top-left
                    Text(category.displayName)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    // Icon at bottom-right
                    HStack {
                        Spacer()
                        Image(systemName: category.icon)
                            .font(.system(size: 36, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white.opacity(hasAnySelection && !isSelected ? 0.3 : 0.9))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                    }
                }
            }
            .frame(height: 160) // Fixed height for all cards
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .aspectRatio(isFullWidth ? 2.5 : 1.0, contentMode: .fit)
            .shadow(
                color: isSelected ? category.borderColor.opacity(0.5) : .clear,
                radius: isSelected ? 16 : 0,
                x: 0,
                y: isSelected ? 6 : 0
            )
        }
        .buttonStyle(SquishyButtonStyle())
        .opacity(isVisible ? 1.0 : 0.0)
        .offset(y: isVisible ? 0 : 20)
        .animation(.easeOut(duration: 0.3), value: isSelected)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(Double(categoryIndex) * 0.05)) {
                isVisible = true
            }
        }
    }
    
    private var categoryIndex: Int {
        BentoCategory.categories.firstIndex(where: { $0.id == category.id }) ?? 0
    }
}

// MARK: - CategorySelectionView

struct CategorySelectionView: View {
    let selectedCategory: QuizCategory?
    let handleSelectCategory: (QuizCategory) -> Void
    let handleNext: () -> Void
    
    // Track selected category by unique ID to handle Algorithm/Data Structure
    @State private var selectedCategoryId: String?
    
    private var hasSelectedCategory: Bool {
        selectedCategoryId != nil
    }
    
    private let cardSpacing: CGFloat = 16
    
    var body: some View {
        ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // App Title with Gradient
                    titleHeader
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    
                    // Bento Grid using VStack/HStack
                    categoryGrid
                        .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Next Button (hidden initially, fade in on selection)
                    if hasSelectedCategory {
                        nextButton
                            .padding(.horizontal, 20)
                            .padding(.bottom, 32)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
        }
        .premiumBackground()
        .onChange(of: selectedCategory) { _, newValue in
            // Clear selectedCategoryId when category is deselected
            if newValue == nil {
                selectedCategoryId = nil
            }
        }
    }
    
    // MARK: - Title Header
    
    private var titleHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Dev60s")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.white,
                            Color.white.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("Choose your topic")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
        }
    }
    
    // MARK: - Category Grid (VStack/HStack implementation)
    
    private var categoryGrid: some View {
        VStack(spacing: cardSpacing) {
            // Process categories in pairs
            let categories = BentoCategory.categories
            let pairCount = categories.count / 2
            let hasOddItem = categories.count % 2 != 0
            
            // Add pairs of cards
            ForEach(0..<pairCount, id: \.self) { pairIndex in
                HStack(spacing: cardSpacing) {
                    // First card in pair
                    categoryCardView(categories[pairIndex * 2], index: pairIndex * 2)
                    
                    // Second card in pair
                    categoryCardView(categories[pairIndex * 2 + 1], index: pairIndex * 2 + 1)
                }
            }
            
            // Add final odd item if exists (spans full width)
            if hasOddItem {
                categoryCardView(categories[categories.count - 1], index: categories.count - 1)
            }
        }
    }
    
    private func categoryCardView(_ category: BentoCategory, index: Int) -> some View {
        let categories = BentoCategory.categories
        let isLastOddItem = categories.count % 2 != 0 && index == categories.count - 1
        
        // Use unique ID-based selection to fix Algorithm/Data Structure bug
        let isSelected = category.id == selectedCategoryId
        
        return BentoCategoryCard(
            category: category,
            isSelected: isSelected,
            hasAnySelection: hasSelectedCategory,
            isFullWidth: isLastOddItem,
            action: {
                // Always use unique ID to ensure correct selection
                selectedCategoryId = category.id
                handleSelectCategory(category.quizCategory)
            }
        )
    }
    
    // MARK: - Next Button
    
    private var nextButton: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            handleNext()
        }) {
            HStack(spacing: 8) {
                Text("Next")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color.white.opacity(0.95)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(SquishyButtonStyle())
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: hasSelectedCategory)
    }
}

// MARK: - Preview

#Preview {
    CategorySelectionView(
        selectedCategory: nil,
        handleSelectCategory: { _ in },
        handleNext: {}
    )
}
