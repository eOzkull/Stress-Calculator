# 📊 Stress Calculator App

A comprehensive **Stress Calculator application** built with Flutter that evaluates a user's stress level using cardiovascular physiological inputs: **systolic blood pressure**, **diastolic blood pressure**, **pulse rate**, and optionally **age** and **name**.

It is available as a **web application**, **Android APK**, and **iOS** app.

---

## 🚀 Features

- 🔢 Calculates stress using systolic BP, diastolic BP, and pulse rate (with optional age-adjusted scoring)
- 📐 Uses a weighted cardiovascular stress index (MAP, pulse pressure, RPP) with normalization, clamping, and age adjustment
- 🧮 Real-time calculation with animated result display
- 💡 Personalized recommendations with multiple therapeutic techniques (breathing, meditation, physical, sensory, cognitive, social) based on stress level
- 📈 History tracking with local storage and trend analysis
- 📊 Statistical analysis and stress trend visualization (charts)
- 🌙 Dark / Light / System theme support
- 🌐 Web, Android, and iOS support

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **Platforms:** Web, Android, iOS
- **Key dependencies:**
  - `shared_preferences` – local data persistence (history, settings)
  - `fl_chart` – stress trend charts and visualizations
  - `flutter_animate` – UI animations
  - `intl` – date/time formatting
  - `url_launcher` – external link support

---

## 🧠 Stress Calculation Logic

The calculator uses a **weighted cardiovascular stress index** based on four physiological indicators.

### 🔹 Cardiovascular Indicators

| Indicator | Formula | Weight |
|-----------|---------|--------|
| Mean Arterial Pressure (MAP) | `diastolicBP + (systolicBP - diastolicBP) / 3` | 25% |
| Pulse Pressure (PP) | `systolicBP - diastolicBP` | 20% |
| Rate Pressure Product (RPP) | `systolicBP × pulseRate` | 35% |
| Heart Rate (HR) Factor | Zone-based multiplier (0.8 – 1.5) | 20% |

Each indicator is normalized against healthy adult averages (MAP: 93 mmHg, PP: 40 mmHg, RPP: 9600) and clamped to prevent extreme outliers. An optional **age adjustment factor** is applied when age is provided (under 30: ×1.1, over 60: ×0.9).

The final composite score is mapped to a **0–100 scale**.

---

## 📊 Stress Level Interpretation

| Score Range | Level | Emoji |
|-------------|-------|-------|
| 0 – 20 | Relaxed | 😌 |
| 20 – 40 | Mild Stress | 🙂 |
| 40 – 60 | Moderate Stress | 😰 |
| 60 – 80 | High Stress | 😫 |
| 80 – 100 | Critical Stress | 🚨 |

---

## 🔮 Future Improvements

- Add more health parameters (oxygen level, sleep, temperature)
- Unit conversion support (e.g., kPa for blood pressure)
