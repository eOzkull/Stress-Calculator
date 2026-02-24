# Contributing

Thank you for considering contributing to Stress Calculator! Please take a moment to review these guidelines.

## Code of Conduct

By participating in this project, you agree to abide by the [Code of Conduct](CODE_OF_CONDUCT.md).

## How to Contribute

### Reporting Bugs

Before submitting a bug report, please check the [existing issues](../../issues) to avoid duplicates.

When filing a bug report, include:
- A clear, descriptive title
- Steps to reproduce the problem
- Expected vs actual behaviour
- Your environment (OS, Flutter version, device/emulator)

### Suggesting Features

Open a [feature request issue](../../issues/new?template=feature_request.md) with:
- A clear description of the proposed feature
- The motivation / use case behind it
- Any alternatives you have considered

### Pull Requests

1. Fork the repository and create your branch from `main`:
   ```bash
   git checkout -b feature/my-new-feature
   ```
2. Make your changes and add tests where applicable.
3. Ensure all tests pass.
4. Commit your changes following [Conventional Commits](https://www.conventionalcommits.org/):
   ```
   feat: add new feature
   fix: correct a bug
   docs: update documentation
   ```
5. Push to your fork and open a Pull Request against `main`.
6. Fill in the pull request template completely.

## Development Setup

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **≥ 3.0.0**
- Dart **≥ 3.0.0** (bundled with Flutter)
- An IDE such as [VS Code](https://code.visualstudio.com/) (with the Flutter extension) or [Android Studio](https://developer.android.com/studio)

### Getting started

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/Stress-Calculator.git
cd Stress-Calculator/App

# Install dependencies
flutter pub get

# Run the app on a connected device / emulator
flutter run

# Run the test suite
flutter test
```

### Useful commands

```bash
# Analyse code for issues
flutter analyze

# Auto-fix simple lint issues
dart fix --apply

# Format code
dart format .
```

## Style Guide

- Follow the coding conventions already present in the project.
- Run `flutter analyze` before committing – there should be no new warnings or errors.
- Keep commits small and focused.
- Write clear commit messages.
