# Gemini Code Assistant Context

This document provides context for the Gemini Code Assistant to understand the `sequencia-party-game` project.

## Project Overview

`sequencia-party-game` is a mobile party game built with Flutter. The game is designed to test synchronization and ordering skills among friends in a fun and interactive way.

### Core Technologies

*   **Framework:** Flutter
*   **State Management:** `provider` with `ChangeNotifier`
*   **Dependency Injection:** `get_it` and `injectable`
*   **Backend/Database:** Firebase Firestore is used to fetch game themes dynamically.
*   **Monetization:** Google Mobile Ads
*   **Routing:** Custom routing solution implemented in `lib/router/`.
*   **Localization:** The app supports multiple languages, configured in `l10n.yaml` and implemented using `flutter_localizations`.

### Architecture

The project follows a feature-driven architecture with a clear separation of concerns.

*   `lib/features/`: Contains the core features of the application, each typically divided into:
    *   `controller/`: Business logic and state management (`ChangeNotifier`).
    *   `domain/`: Entities and core domain logic.
    *   `screens/` or `presentation/`: UI (Widgets).
*   `lib/common/`: Shared components, including a custom design system (`design_system/`) and widgets.
*   `lib/core/`: Core functionalities like Ad service, constants, and asset handlers.
*   `lib/di/`: Dependency injection setup using `injectable`.
*   `lib/router/`: Navigation and routing logic.

## Building and Running

### Prerequisites

*   Flutter SDK is installed.
*   An emulator/simulator is running or a physical device is connected.

### Running the App (Debug)

To run the application in debug mode, use the following command:

```shell
flutter run
```

### Building for Production

To create a release build, use the standard Flutter build commands:

*   **Android:** `flutter build apk --release`
*   **iOS:** `flutter build ipa --release`

### Code Generation

The project uses code generation for dependency injection (`injectable`). If you make changes to injectable classes, you need to run the build runner:

```shell
flutter pub run build_runner build --delete-conflicting-outputs
```

## Development Conventions

*   **State Management:** Application state is managed using `ChangeNotifier` and `Provider`. Business logic is encapsulated in `*Controller` classes that extend `ChangeNotifier`.
*   **Dependency Injection:** Dependencies are injected using the `get_it` and `injectable` packages. Register services and controllers in the appropriate modules and use `GetIt.I<MyService>()` to access them.
*   **Styling:** The project has a custom design system located in `lib/common/design_system`. Use the predefined tokens for colors, fonts, and spacing to maintain a consistent UI.
*   **Linting:** The project uses `flutter_lints` and `dart_code_metrics` for static analysis. The rules are defined in `analysis_options.yaml`. Please adhere to these rules.
*   **File Naming:** Files should be named using `snake_case`.
*   **Branching and Commits:** Follow conventional commit message standards.
