# GEMINI.md — Habit Tracking App Development Charter

> Gemini CLI reads this file automatically from the project root. All code generation and suggestions must follow these directives.

---

## Project Overview

- **Project Name:** Habit Tracking App
- **Description:** A habit tracking app with social accountability features. Users create habits, track daily completions, and stay motivated through streaks and clean visual feedback.
- **Platform Targets:** Android, iOS
- **Flutter Channel:** Stable (latest)
- **Dart SDK:** 3.x+ (null safety enforced)

---

## General Instructions

- You are an expert Flutter/Dart developer and my AI pair programmer.
- Follow [Effective Dart](https://dart.dev/effective-dart) style conventions strictly.
- All code must be Dart 3+ compatible with strict null safety.
- Use `const` constructors and widgets wherever possible.
- All public classes and methods must include `///` doc comments.
- Do NOT use deprecated APIs. Always use the latest recommended approach.
- Be concise and direct. Skip boilerplate explanations unless asked.
- When proposing changes, show complete files or clear diffs — not fragments.
- If a task is ambiguous, ask clarifying questions before generating code.
- Flag potential bugs, anti-patterns, or performance issues proactively.

---

## Design Philosophy

### Visual Direction: Beautiful Minimalism

- **Design System:** Material 3 (Material You) with `useMaterial3: true`.
- **Icons:** Use ONLY `Icons.*` from Flutter's built-in Material Icons library. No icon packages.
- **Typography:** Clean hierarchy using Material 3 type scale (`displayLarge`, `titleMedium`, `bodySmall`, etc.). Limit to 2–3 font weights per screen.
- **Color:** Define a tight `ColorScheme` with a single primary accent. Use `ColorScheme.fromSeed()` for harmonious palette generation. Generous use of surface and background tones. Avoid harsh contrasts — let whitespace breathe.
- **Spacing:** Consistent spacing using multiples of 4dp (4, 8, 12, 16, 24, 32, 48). Define spacing constants — never use magic numbers.
- **Layout Principles:**
  - Generous whitespace and padding (minimum 16dp horizontal page padding).
  - Cards with subtle elevation (0–2) and rounded corners (12–16dp radius).
  - Clean separation between sections — avoid visual clutter.
  - One primary action per screen. Secondary actions are subdued.
  - Smooth, purposeful animations (200–400ms) using `AnimatedContainer`, `AnimatedSwitcher`, `Hero`, etc.
- **Empty States:** Always design meaningful empty states with an icon, message, and CTA.
- **Dark Mode:** Support both light and dark themes from the start via `ColorScheme.fromSeed()` with `brightness` parameter.

### UI Component Guidelines

- Habit cards should feel tactile — satisfying tap feedback with `InkWell` ripple and subtle scale animation on completion.
- Streak counters should be visually prominent but not loud — think calm confidence.
- Progress indicators should be circular or linear with smooth animated transitions.
- Bottom navigation or top tabs for main sections — keep navigation flat and simple.
- Avoid bottom sheets for critical actions. Use them only for secondary options.

---

## Architecture & State Management

- **Architecture:** Feature-first folder structure with clean separation.
- **State Management:** Use `ChangeNotifier` + `Provider` for simplicity. No Bloc, no Riverpod — keep it lightweight.
- Each feature is self-contained under `lib/features/<feature_name>/`:

```
lib/
├── app/
│   ├── theme/
│   │   ├── app_theme.dart          # Light & dark ThemeData
│   │   ├── app_colors.dart         # ColorScheme + custom colors
│   │   └── app_spacing.dart        # Spacing constants (s4, s8, s12, s16...)
│   ├── router/
│   │   └── app_router.dart
│   └── app.dart
├── core/
│   ├── constants/
│   ├── extensions/                 # DateTime, String, BuildContext extensions
│   ├── utils/
│   └── widgets/                    # Shared reusable widgets
│       ├── app_card.dart
│       ├── empty_state.dart
│       └── animated_check.dart
├── features/
│   ├── habits/
│   │   ├── models/
│   │   │   └── habit.dart
│   │   ├── services/
│   │   │   └── habit_service.dart  # In-memory data + ChangeNotifier
│   │   └── screens/
│   │       ├── habits_screen.dart
│   │       ├── habit_detail_screen.dart
│   │       └── widgets/
│   │           ├── habit_card.dart
│   │           └── streak_indicator.dart
│   ├── tracking/
│   │   ├── models/
│   │   ├── services/
│   │   └── screens/
│   └── settings/
│       └── screens/
└── main.dart
```

---

## Data & Persistence

### In-Memory First

- **Primary storage: In-memory using Dart collections** (`List`, `Map`) inside `ChangeNotifier` services.
- No SQLite, no Hive, no SharedPreferences, no Firebase for data storage.
- Data lives in service classes that extend `ChangeNotifier` and are provided via `Provider`.
- Data resets on app restart — this is intentional for the current phase.
- Seed the app with sample/demo data on first launch so it never starts empty.

### Data Model Conventions

- Models are simple Dart classes with `final` fields and `copyWith()` methods.
- Use `uuid` package (or simple `DateTime.now().millisecondsSinceEpoch.toString()`) for IDs.
- Models should have `toJson()` / `fromJson()` for future persistence migration readiness.
- Keep models immutable — return new instances on modification.

```dart
// Example pattern:
class Habit {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<DateTime> completedDates;

  const Habit({...});

  Habit copyWith({...}) => Habit(...);

  bool isCompletedToday() => completedDates.any((d) =>
    d.year == DateTime.now().year &&
    d.month == DateTime.now().month &&
    d.day == DateTime.now().day,
  );
}
```

---

## Coding Style & Conventions

### Naming

| Element | Style | Example |
|---|---|---|
| Files | `snake_case` | `habit_card.dart` |
| Classes/Enums | `UpperCamelCase` | `HabitService`, `HabitFrequency` |
| Variables/Functions | `lowerCamelCase` | `fetchHabits`, `isCompleted` |
| Constants | `lowerCamelCase` | `defaultPadding`, `animDuration` |
| Private members | `_prefix` | `_habits`, `_onTap` |

### Widget Guidelines

- Prefer `StatelessWidget` unless local mutable state is genuinely needed.
- Extract widgets into separate files at ~60–80 lines or when reused.
- Always add `Key` parameter to public widgets.
- Use `const` constructors aggressively.
- Maximum widget nesting: 4–5 levels. Extract beyond that.

### Dart Best Practices

- `final` for all variables that don't change after assignment.
- `switch` expressions (Dart 3) over `if/else` chains.
- Pattern matching and sealed classes for state exhaustiveness.
- `collection if` / `collection for` over imperative list building.
- `extension` methods for clean type augmentation.
- `async/await` only — no `.then()` chains.

---

## Navigation

- Use `go_router` for declarative routing.
- Define all routes as constants in `app_router.dart`.
- Keep navigation flat — avoid deep nesting.

---

## Testing

- Unit tests for all service classes and data logic.
- Widget tests for key screens and interactive components.
- Use `mocktail` for mocking.
- Mirror `lib/` structure under `test/`.
- File naming: `*_test.dart`.

---

## Performance

- `const` widgets everywhere possible.
- `ListView.builder` for scrollable lists.
- No computation in `build()`.
- Use `RepaintBoundary` for animated components (streak rings, progress bars).
- Animations: 200–400ms with `Curves.easeInOut` as default.

---

## Git Conventions

- Conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`.
- Atomic commits — one logical change per commit.
- Example: `feat: add streak counter animation to habit card`

---

## Forbidden Patterns

- ❌ `print()` — use `debugPrint()` or a logger.
- ❌ `dynamic` — always type explicitly.
- ❌ `setState` for shared state — use `ChangeNotifier` + `Provider`.
- ❌ God classes or files exceeding ~250 lines.
- ❌ Suppressing linter warnings without documented reason.
- ❌ `.then()` chains — use `async/await`.
- ❌ Hardcoded colors, text styles, or dimensions — use theme and constants.
- ❌ Third-party icon packages — use `Icons.*` only.
- ❌ External persistence packages (SQLite, Hive, SharedPreferences) — in-memory only.
- ❌ Over-engineering — no unnecessary abstractions. Keep it simple and readable.

---

## Project-Specific Notes

```
# Habit Tracking App Specifics
# - Social accountability features are a key differentiator.
# - Streak visualization is critical to engagement — make it feel rewarding.
# - Seed data: Include 3–4 demo habits on first launch (Exercise, Read, Meditate, Drink Water).
# - Future: Will migrate to local persistence (Hive/Isar) then Firebase.
# - Future: Push notifications for habit reminders.
# - Monetization: Lifetime licenses, potential premium features.
```

---

*Last updated: 2025-02-21*
