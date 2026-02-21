# 📊 Stress Calculator App

A simple and interactive **Stress Calculator application** that evaluates a user's stress level using basic physiological inputs like **pulse rate** and **blood pressure**.

This project demonstrates engineering and health-based logic using a clean UI and modular structure.  
It is available as both a **web application** and an **Android APK**.

---

## 🚀 Features

- 🔢 Calculates stress using pulse rate and blood pressure  
- 📐 Uses simple rule-based physiological thresholds  
- 🧮 Real-time calculation and instant result display  
- 🌐 Web-based version (HTML, CSS, JavaScript)  
- 📱 Android APK version for mobile devices  
- 🧩 Beginner-friendly and easy to understand  
- 🎯 Useful for educational and demonstration purposes  

---

## 🛠️ Tech Stack

### 🌐 Web Version
- HTML  
- CSS  
- JavaScript  

### 📱 Mobile Version
- Converted into **Android APK**
- Installable on Android devices


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

## 💻 JavaScript Logic Used in App

```javascript
let score = 0;

if (pulse > 90) score += 1;
if (bp > 130) score += 1;

let result = "";

if (score === 0) {
  result = "No Stress";
} else if (score === 1) {
  result = "Mild Stress";
} else {
  result = "High Stress";
}
```

## 🔮 Future Improvements

- Add more health parameters (oxygen level, sleep, temperature)

- Graph visualization of stress trends

- Unit conversion support

- User data storage & history tracking

- iOS version of the app
