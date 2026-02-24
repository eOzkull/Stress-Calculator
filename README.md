# 📊 Stress Calculator App

A comprehensive **Flutter-based Stress Calculator** that evaluates a user's cardiovascular stress level using **systolic and diastolic blood pressure**, **pulse rate**, and optionally **age** and **name**.

The app uses a sophisticated weighted cardiovascular stress index and delivers **personalized recommendations**, **history tracking**, **statistical analysis**, and **trend visualization**.  
It supports **Web**, **Android**, and **iOS** platforms.

---

## 🚀 Features

- 🔢 Calculates stress from systolic BP, diastolic BP, pulse rate, and optional age/name
- 📐 Uses a weighted cardiovascular stress index (MAP, Pulse Pressure, RPP) with normalization, clamping, and age adjustment
- 🧮 Real-time calculation with animated result display
- 🎨 Dark / Light theme support
- 📈 History tracking with statistical analysis and trend visualization (fl_chart)
- 💡 Personalized recommendations using multiple therapeutic techniques (breathing, meditation, physical, sensory, cognitive, social)
- 🌐 Web, Android, and iOS support

---

## 🛠️ Tech Stack

- **Framework**: Flutter (Dart)
- **Platforms**: Web, Android, iOS
- **Key Dependencies**:
  - `shared_preferences` – local data persistence for history
  - `intl` – date/time formatting
  - `url_launcher` – external links in recommendations
  - `flutter_animate` – UI animations
  - `fl_chart` – stress trend charts

---

## 🧠 Stress Calculation Logic

The calculator uses a **composite cardiovascular stress score** (0–100 scale) derived from multiple weighted indicators.

### Inputs

| Input | Description |
|-------|-------------|
| Systolic BP (mmHg) | Upper blood pressure value (valid range: 70–250) |
| Diastolic BP (mmHg) | Lower blood pressure value (valid range: 40–150) |
| Pulse Rate (BPM) | Heart rate (valid range: 40–200) |
| Age *(optional)* | Used for age-adjusted calculation |
| Name *(optional)* | Personalizes result display |

### Formula

```
MAP  = diastolicBP + (systolicBP - diastolicBP) / 3
PP   = systolicBP - diastolicBP
RPP  = systolicBP × pulseRate

stressScore = (MAP/93 × 25) + (PP/40 × 20) + (RPP/9600 × 35) + (hrFactor × 20)
stressScore = ((stressScore - 80) × 1.25) × ageFactor   [clamped to 0–100]
```

- **MAP** (Mean Arterial Pressure) — weight: **25%**
- **PP** (Pulse Pressure) — weight: **20%**
- **RPP** (Rate Pressure Product, cardiac workload) — weight: **35%**
- **HR Factor** (heart rate zone) — weight: **20%**
- **Age factor**: `1.1` for age < 30, `0.9` for age > 60, `1.0` otherwise

---

## 📊 Stress Level Interpretation

| Score Range | Level | Emoji |
|-------------|-------|-------|
| 0 – 20 | 😌 Relaxed | Cardiovascular markers indicate a relaxed state |
| 20 – 40 | 🙂 Mild Stress | Slight elevation; manageable with breathing exercises |
| 40 – 60 | 😰 Moderate Stress | Body working harder than optimal; consider a break |
| 60 – 80 | 😫 High Stress | Significant cardiovascular load; relaxation recommended |
| 80 – 100 | 🚨 Critical Stress | Acute stress response; calming techniques required |

---

## 🔮 Future Improvements

- Add more health parameters (oxygen saturation, sleep quality, temperature)
- Unit conversion support (e.g., kPa ↔ mmHg)
