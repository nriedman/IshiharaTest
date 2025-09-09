# Ishihara Test

An iOS application for conducting Ishihara color blindness tests. This app provides interactive color vision testing with multiple test types and comprehensive result tracking.

## Overview

The Ishihara Test app implements digital versions of the classic Ishihara color vision tests used to detect color blindness. Users can take tests specifically designed for different types of color vision deficiencies and track their performance over time.

### Features

- **Multiple Test Types**: Red-Green, Blue-Yellow, and Monochromatic vision tests
- **Timed Testing**: Configurable time limits per test plate
- **Results Tracking**: Persistent storage of test results with SwiftData
- **Analytics**: Aggregate performance charts and individual test breakdowns
- **Customizable Settings**: Adjustable test parameters and preferences

### Supported Color Vision Deficiencies

- **Red-Green**: Detects Deuteranomaly, Protanomaly, Protanopia, Deuteranopia
- **Blue-Yellow**: Detects Tritanomaly, Tritanopia  
- **Monochromatic**: Detects Monochromacy/Achromatopsia

## Project Structure

```
IshiharaTest/
├── IshiharaTest/                    # Xcode project directory
│   ├── IshiharaTest.xcodeproj       # Xcode project file
│   └── IshiharaTest/                # Source code
│       ├── IshiharaTestApp.swift    # App entry point
│       ├── Model/                   # Data models and business logic
│       │   ├── IshiharaTest/        # Core test logic
│       │   └── TestResults/         # Result persistence
│       ├── UI/                      # User interface components
│       │   ├── HomeTab/             # Main test interface
│       │   ├── ResultsTab/          # Results and analytics
│       │   ├── IshiharaTestSheet/   # Test execution views
│       │   ├── SettingsSheet/       # Configuration
│       │   └── Utilities/           # Shared components
│       └── Assets.xcassets/         # Images and test plates
└── README.md                        # This file
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Dependencies

- **SVG2Path**: For rendering test plate graphics from SVG files
- **SwiftUI**: Native UI framework
- **SwiftData**: Data persistence

## Building and Running

1. Open the project in Xcode:
   ```bash
   open IshiharaTest/IshiharaTest.xcodeproj
   ```

2. Build and run on iOS Simulator or device:
   - Select your target device/simulator
   - Press ⌘+R to build and run

### Command Line Building

```bash
# Navigate to project directory
cd IshiharaTest/

# Build for iOS Simulator
xcodebuild -scheme IshiharaTest -destination 'platform=iOS Simulator,name=iPhone 15' build

# Run tests (when available)  
xcodebuild test -scheme IshiharaTest -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Architecture

The app follows SwiftUI best practices with:

- **@Observable** pattern for reactive test state management
- **SwiftData** for persistent result storage  
- **@AppStorage** for user preferences
- **Timer-based** test progression with configurable limits
- **Tab-based navigation** for organized user experience

## Usage

1. **Take a Test**: Select a test type from the home screen
2. **Configure Settings**: Adjust test length and time limits
3. **View Results**: Check individual test results and aggregate analytics
4. **Track Progress**: Monitor performance trends over time
