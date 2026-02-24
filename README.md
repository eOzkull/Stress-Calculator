# 📊 Stress Calculator App

> A comprehensive Flutter app that estimates your stress levels using cardiovascular markers and provides personalised recommendations to help you relax and recover.

## Table of Contents

- [About](#about)
- [Features](#features)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Tech Stack](#tech-stack)
- [Stress Calculation Logic](#stress-calculation-logic)
- [Stress Level Interpretation](#stress-level-implementation)
- [Contributing](#contributing)
- [License](#license)

# About
A simple and interactive **Stress Calculator application** that evaluates a user's stress level using basic physiological inputs like **pulse rate** and **blood pressure**.

This project demonstrates engineering and health-based logic using a clean UI and modular structure.  
It is available as both a **web application** and an **Android APK**.

---

## 🚀 Features

- **Stress Calculation** – Enter blood pressure and pulse rate for an instant stress-level analysis (Relaxed → Mild → Moderate → High → Critical).
- **Personalised Recommendations** – Breathing exercises, meditation techniques, physical activities, sensory grounding, and cognitive strategies matched to your stress level.
- **History Tracking** – Every measurement is saved locally so you can review past readings at a glance.
- **Statistics & Trends** – Interactive charts and trend analysis to visualise how your stress changes over time.
- **Mood Check-In** – Log a quick emoji mood snapshot from the home screen.
- **Light & Dark Themes** – Toggle between light and dark mode; preference is saved across sessions.
- **Multi-person support** – Optionally label each measurement (e.g. "Dad", "Morning Check") to track multiple people.
- **Cross-platform** – Runs on Android, iOS, Web, Windows, macOS, and Linux.

simply put :-

- 🔢 Calculates stress using pulse rate and blood pressure  
- 📐 Uses simple rule-based physiological thresholds  
- 🧮 Real-time calculation and instant result display  
- 🌐 Web-based version (HTML, CSS, JavaScript)  
- 📱 Android APK version for mobile devices  
- 🧩 Beginner-friendly and easy to understand  
- 🎯 Useful for educational and demonstration purposes  

---

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

## 🛠️ Tech Stack

### 🌐 Web Version
- HTML  
- CSS  
- JavaScript  

### 📱 Mobile Version
- Converted into **Android APK**
- Installable on Android devices

| Layer | Technology |
|---|---|
| Framework | [Flutter](https://flutter.dev) 3.x |
| Language | Dart 3.x |
| Charts | [fl_chart](https://pub.dev/packages/fl_chart) |
| Animations | [flutter_animate](https://pub.dev/packages/flutter_animate) |
| Persistence | [shared_preferences](https://pub.dev/packages/shared_preferences) |
| Localisation helpers | [intl](https://pub.dev/packages/intl) |


---

## 🧠 Stress Calculation Logic

The calculator uses a **2-step rule-based model** to determine stress.

---

### 🔹 Step 1: Stress Score Calculation

Excel Logic:
=IF(A2>90,1,0)+IF(B2>130,1,0)


**Inputs:**

- **A2 → Pulse Rate (BPM)**
- **B2 → Systolic Blood Pressure (mmHg)**

**Rules:**

- If Pulse > 90 → add **1 point**
- If BP > 130 → add **1 point**

👉 This produces a **Stress Score (C2)** between **0 and 2**

---

### 🔹 Step 2: Stress Level Classification

Excel Logic:
=IF(C2=0,"No Stress",IF(C2=1,"Mild Stress","High Stress"))


---

## 📊 Stress Level Interpretation

| Stress Score | Condition | Result |
|--------------|----------|--------|
| **0** | Both values normal | 🟢 No Stress |
| **1** | One value elevated | 🟡 Mild Stress |
| **2** | Both values elevated | 🔴 High Stress |

---

## 🔮 Future Improvements

- Add more health parameters (oxygen level, sleep, temperature)

- Graph visualization of stress trends

- Unit conversion support

- User data storage & history tracking

- iOS version of the app

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to get started.

## License

[![License: Apache2.0](https://img.shields.io/badge/License-Apache2.0-red.svg)](LICENSE)
This project is licensed under the APACHE2.0 License – see the [LICENSE](LICENSE) file for details.