# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed

### Deprecated

### Removed

### Fixed

### Security

---

## [1.0.0] – Initial Release

### Added
- **Stress calculation engine** – composite score (0–100) derived from Mean Arterial Pressure, Pulse Pressure, and Rate Pressure Product; optional age normalisation factor.
- **Five stress categories** – Relaxed, Mild, Moderate, High, and Critical – each with a descriptive summary.
- **Personalised recommendations** – science-backed techniques across five domains: breathing exercises, meditation, physical activity, sensory grounding, and cognitive reframing; matched to the detected stress level.
- **Measurement history** – all readings persisted locally via `shared_preferences` with full CRUD support.
- **Statistics screen** – interactive trend charts (powered by `fl_chart`) and summary statistics across saved measurements.
- **Mood check-in** – quick emoji mood logger on the home screen with last-mood display.
- **Light / Dark theme** – toggle with persistent preference; smooth animated transitions via `flutter_animate`.
- **Multi-person labelling** – optional name field per measurement (e.g. "Dad", "Morning Check").
- **Trend analysis** – contextual message comparing the latest result with the previous reading.
- **Cross-platform support** – Android, iOS, Web, Windows, macOS, and Linux targets.
