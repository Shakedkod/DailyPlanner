# Daily Planner

A daily and weekly scheduling application built with Flutter to help manage routines, plan tasks, and track daily activities.

## Features

- Interactive Date Timeline: Quick navigation between days using a horizontal date picker.
- Task Management: Create, edit, and complete tasks with custom titles, details, start times, and durations.
- Visual Customization: Assign custom colors and icons to differentiate tasks.
- Recurring Tasks: Support for repetitive task schedules (such as daily, weekly, or monthly).
- Automatic Routine Anchors: Built-in daily start and end routine markers (Rise and Shine, Wind Down).
- Bidirectional Text: Support for dynamic RTL (Right-to-Left) and LTR text input.
- Local Persistence: Fast offline storage powered by Hive.
- Dynamic Theming: Material 3 styling with dynamic color theming and dark mode support.

## Tech Stack

- Flutter SDK (Dart 3.5+)
- Hive and hive_flutter for local database storage
- dynamic_color for dynamic Material color schemes
- date_picker_timeline for date selection
- flutter_colorpicker and flutter_iconpicker for customization

## Getting Started

### Prerequisites

Ensure you have the following installed on your machine:

- Flutter SDK (version 3.24.x or newer recommended)
- Dart SDK (^3.5.2)
- Android Studio / Android SDK (or another supported platform development environment)

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd daily_planner
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. (Optional) Regenerate Hive adapters if model changes are made:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Running the App

Run the application in debug mode on a connected device or emulator:

```bash
flutter run
```

### Building for Production

To build an Android APK:

```bash
flutter build apk
```

The compiled APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`

## Project Structure

```text
lib/
|-- box.dart               # Hive database box initialization and keys
|-- main.dart              # Application entry point and theme setup
|-- components/            # Reusable UI components (date picker, task list, inputs)
|-- models/                # Data models and generated type adapters (Task)
|-- pages/                 # App screens (Home, Add Task, Edit Task)
`-- services/              # Helper utilities (date and color services)
```

## License

This project is private and intended for personal use.
