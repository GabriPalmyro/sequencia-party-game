# Repository Guidelines

## Project Structure & Module Organization
- `lib/` hosts all Dart code. Keep shared utilities under `lib/common`, cross-cutting services in `lib/core`, dependency wiring in `lib/di`, and routing helpers in `lib/router`. Feature-specific UI, models, and controllers belong in `lib/features/<feature_name>`.
- `assets/` contains images, audio, and localized strings referenced in `pubspec.yaml`. Add new assets there and register them before use.
- Platform folders (`android/`, `ios/`, `web/`, `windows/`) should only contain changes required for native integrations or build settings. Keep Flutter logic in `lib/`.

## Build, Test, and Development Commands
- `flutter pub get` — Sync dependencies after modifying `pubspec.yaml`.
- `flutter analyze` — Run static analysis; fix all warnings before pushing.
- `flutter test --coverage` — Execute Dart tests and update `coverage/lcov.info` for CI review.
- `flutter run -d chrome` or `flutter run -d ios` — Launch the game locally with hot reload on the target device.
- `flutter build apk --release` and `flutter build web` — Produce distributable artifacts for Android and web releases.

## Coding Style & Naming Conventions
- Follow the default Dart formatter: run `dart format lib test` (CI checks formatted code).
- Prefer `final` and `const` whenever possible; avoid mutable top-level state.
- Name widgets with `*Widget` suffix, view models with `*Controller`, and files using `snake_case.dart`.
- Keep feature modules self-contained: UI widgets, state, and data sources stay under the same feature folder.

## Testing Guidelines
- Use the Flutter `test` package for unit and widget tests. Place files under `test/<feature>/<name>_test.dart`, mirroring `lib/`.
- Name tests descriptively using `group` and `test` blocks; ensure golden tests live under `test/golden/`.
- Aim for recent changes to include relevant unit coverage and at least one widget test when modifying UI behavior.

## Commit & Pull Request Guidelines
- Follow the existing Conventional Commits style (`feat:`, `fix:`, `chore:`, etc.). Scope is optional but helpful (`feat(game_controller): ...`).
- Each PR should describe the problem, solution, and testing evidence (commands run, screenshots for UI tweaks).
- Reference related issues or tickets with `Closes #123`. Request review once CI (analyze + test) is green.

## Environment & Configuration Tips
- Keep `firebase_options.dart` updated via `flutterfire configure` whenever Firebase settings change.
- Secrets belong in platform-specific config files or environment variables, never in source control. Use `.env` loading helpers from `lib/helpers/` for runtime config.
