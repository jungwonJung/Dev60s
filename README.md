# Dev60s

A premium iOS quiz app for developers preparing for technical interviews. Dev60s delivers a fast, focused 60-second format per question, polished SwiftUI visuals, and detailed results to help you practice under pressure.

## Features

- 60-second timer per question (optional strict mode)
- Multiple categories (Computer Science, Swift, Mobile Dev, Algorithm, Data Structure)
- Difficulty levels: Easy, Normal, Hard
- Question counts: 20, 30, 40
- Real-time answer feedback with haptics and animations
- Detailed results with performance messaging and incorrect answers list
- Premium bento-style UI with glassmorphic effects and mesh gradients

## Supported Flow

Landing -> Category Selection -> Quiz Setup -> Quiz Session -> Results

## Tech Stack

- Swift 5.9+
- SwiftUI (primary UI)
- UIKit (haptics)
- Combine (state/reactive bindings)
- Minimum iOS 16.0
- No external dependencies

## Architecture

MVVM with a clear separation of concerns:

- Views: SwiftUI screens and UI modifiers
- ViewModels: App flow and quiz session logic
- Models: Quiz data structures and result summaries

## Project Structure

```
Dev60s/
├── Dev60s/
│   ├── Dev60sApp.swift
│   ├── ContentView.swift
│   ├── AppFlowViewModel.swift
│   ├── LandingView.swift
│   ├── CategorySelectionView.swift
│   ├── QuizSetupView.swift
│   ├── QuizQuestionView.swift
│   ├── QuizResultView.swift
│   ├── QuizQuestionViewModel.swift
│   ├── QuizModels.swift
│   ├── QuizDataService.swift
│   ├── PremiumBackground.swift
│   ├── questions.json
│   └── UI/
│       └── SquishyButtonStyle.swift
└── Dev60s.xcodeproj/
```

## Data

Quiz content is stored locally in `Dev60s/questions.json`. This app runs entirely on-device with no backend dependency.

## Getting Started

### Prerequisites

- Xcode 15.0+
- iOS 16.0+ simulator or device

### Installation

```bash
git clone <your-repo-url>
cd Dev60s
open Dev60s.xcodeproj
```

### Run

Select a target device/simulator in Xcode and press `Cmd + R`.

## Development Notes

- Use `.premiumBackground()` for screen consistency
- Keep view logic thin; put state and logic in ViewModels
