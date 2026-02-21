# Stress Calculator

> A comprehensive Flutter app that estimates your stress levels using cardiovascular markers and provides personalised recommendations to help you relax and recover.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Table of Contents

- [About](#about)
- [Features](#features)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Tech Stack](#tech-stack)
- [Contributing](#contributing)
- [License](#license)

## About

Stress Calculator is a cross-platform Flutter application that analyzes your blood pressure (systolic/diastolic) and pulse rate to estimate your current stress level. It uses a composite cardiovascular scoring formula that weighs Mean Arterial Pressure, Pulse Pressure, and Rate Pressure Product to produce a stress score from 0 to 100. The app also considers age as an optional normalization factor and provides science-backed relaxation recommendations tailored to your result.

> **Disclaimer:** This app provides estimates only. Please consult a healthcare professional for medical advice.

## Features

- **Stress Calculation** – Enter blood pressure and pulse rate for an instant stress-level analysis (Relaxed → Mild → Moderate → High → Critical).
- **Personalised Recommendations** – Breathing exercises, meditation techniques, physical activities, sensory grounding, and cognitive strategies matched to your stress level.
- **History Tracking** – Every measurement is saved locally so you can review past readings at a glance.
- **Statistics & Trends** – Interactive charts and trend analysis to visualise how your stress changes over time.
- **Mood Check-In** – Log a quick emoji mood snapshot from the home screen.
- **Light & Dark Themes** – Toggle between light and dark mode; preference is saved across sessions.
- **Multi-person support** – Optionally label each measurement (e.g. "Dad", "Morning Check") to track multiple people.
- **Cross-platform** – Runs on Android, iOS, Web, Windows, macOS, and Linux.

## Screenshots

> Screenshots coming soon.

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **≥ 3.0.0** (Dart ≥ 3.0.0)
- A connected device or emulator (Android / iOS) **or** a desktop/web target enabled in Flutter

Verify your Flutter installation:

```bash
flutter doctor
```

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/eOzkull/Stress-Calculator.git
cd Stress-Calculator/App

# 2. Fetch dependencies
flutter pub get

# 3. Run the app (replace <device-id> with your target, or omit for the default)
flutter run
```

To build a release APK:

```bash
flutter build apk --release
```

## Usage

1. Launch the app.
2. On the **Home** screen you will see a greeting, a mood check-in strip, and three main action cards.
3. Tap **Calculate Stress** → enter your *Systolic BP*, *Diastolic BP*, *Pulse Rate*, and optionally your *Age* and a *Name* label → tap **Calculate Stress Level**.
4. The **Result** screen shows your stress score, category, a description, and a list of personalised recommendations with step-by-step guidance.
5. Use **View Statistics** to explore charts and trends across all saved readings.
6. Use **View History** to browse or delete individual past measurements.

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | [Flutter](https://flutter.dev) 3.x |
| Language | Dart 3.x |
| Charts | [fl_chart](https://pub.dev/packages/fl_chart) |
| Animations | [flutter_animate](https://pub.dev/packages/flutter_animate) |
| Persistence | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| Localisation helpers | [intl](https://pub.dev/packages/intl) |

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to get started.

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.
