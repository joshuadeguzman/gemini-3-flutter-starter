# Habit Tracking App — Gemini CLI Starter Kit

A pre-configured development environment for building **Habit Tracking App** — a minimalist habit tracking app — using **Flutter** and **Gemini CLI** as your AI pair programmer.

This repo contains the `GEMINI.md` project charter and a starter prompt to bootstrap the entire app with Gemini CLI.

---

## What's Inside

| File | Purpose |
|---|---|
| `GEMINI.md` | Project charter — Gemini CLI reads this automatically and follows its rules for all code generation |
| `STARTER_PROMPT.md` | Copy-paste prompt to kick off the full app scaffold in Gemini CLI |
| `setup.sh` | One-command setup script for Gemini CLI + Flutter project initialization |
| `README.md` | You're reading it |

---

## Prerequisites

- **Flutter SDK** — stable channel, 3.x+ ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Node.js** — version 20+ ([Install Node](https://nodejs.org/))
- **Git** — for version control

Verify your setup:

```bash
flutter --version    # Should show 3.x+
node --version       # Should show v20+
git --version
```

---

## Quick Start

### 1. Clone this repo

```bash
git clone https://github.com/YOUR_USERNAME/habit-tracking-app-gemini-starter.git
cd habit-tracking-app-gemini-starter
```

### 2. Run the setup script

```bash
chmod +x setup.sh
./setup.sh
```

This will:
- Install Gemini CLI globally (if not already installed)
- Create the Flutter project
- Copy `GEMINI.md` into the project root
- Open a Gemini CLI session in the project directory

### 3. Paste the starter prompt

Open `STARTER_PROMPT.md`, copy the prompt block, and paste it into the Gemini CLI session. Gemini will read your `GEMINI.md` charter and start building the app according to your specifications.

---

## Manual Setup (if you prefer step-by-step)

### Install Gemini CLI

```bash
# Option A: Install globally (recommended)
npm install -g @google/gemini-cli

# Option B: Run directly without installing
npx https://github.com/google-gemini/gemini-cli
```

### Authenticate

Choose one method:

**Google Account (easiest — 60 req/min free tier):**

```bash
gemini
# Follow the sign-in prompt on first run
```

**API Key (more control — 100 req/day free tier):**

```bash
# 1. Get a key from https://aistudio.google.com/app/apikey
# 2. Set the environment variable:
export GEMINI_API_KEY="your-api-key-here"

# Optional: Add to your shell profile for persistence
echo 'export GEMINI_API_KEY="your-api-key-here"' >> ~/.zshrc
```

### Create the Flutter project

```bash
flutter create --empty habit_tracking_app --platforms=android,ios
cd habit_tracking_app
```

### Copy the charter

```bash
# From the starter kit root:
cp ../GEMINI.md .
```

### Start Gemini CLI

```bash
gemini
```

Gemini will automatically detect and load `GEMINI.md`. You'll see it referenced in the session context. Now paste the prompt from `STARTER_PROMPT.md` to begin.

---

## Using the Flutter Extension (Optional, Recommended)

The [Flutter Extension for Gemini CLI](https://github.com/gemini-cli-extensions/flutter) adds structured commands for project management:

```bash
# Install the extension
gemini extensions install flutter

# Available commands (inside a Gemini CLI session):
# /create-app     — Guided project bootstrap with DESIGN.md + IMPLEMENTATION.md
# /modify         — Structured modification with automated planning
# /commit         — Pre-commit checks + smart commit messages
```

If using `/create-app`, it will generate its own `DESIGN.md` and `IMPLEMENTATION.md`. The `GEMINI.md` charter still applies on top — it governs code style, architecture, and design decisions.

---

## Project Structure (After Generation)

```
habit_tracking_app/
├── GEMINI.md                       # ← Project charter (this drives Gemini)
├── lib/
│   ├── app/
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_spacing.dart
│   │   ├── router/
│   │   │   └── app_router.dart
│   │   └── app.dart
│   ├── core/
│   │   ├── constants/
│   │   ├── extensions/
│   │   └── widgets/
│   ├── features/
│   │   ├── habits/
│   │   │   ├── models/
│   │   │   ├── services/
│   │   │   └── screens/
│   │   ├── tracking/
│   │   └── settings/
│   └── main.dart
├── test/
├── pubspec.yaml
└── README.md
```

---

## Customizing the Charter

The `GEMINI.md` is fully yours to modify. Common tweaks:

- **Change state management:** Swap `ChangeNotifier + Provider` for Riverpod or Bloc in the Architecture section
- **Add persistence:** When ready to migrate from in-memory, remove the "in-memory only" constraint and add your preferred storage (Hive, Isar, Firestore)
- **Adjust design tokens:** Change the seed color, spacing scale, or animation durations
- **Add features:** Update the Project-Specific Notes section as Habit Tracking App evolves

After editing, Gemini picks up changes in the next CLI session automatically.

---

## Tips for Working with Gemini CLI

1. **Be specific** — "Add a circular progress ring to the home summary card using CustomPainter" works better than "make the home screen look better"
2. **Iterate in phases** — Build one screen at a time, test it, then move on
3. **Use `/modify` for changes** — The Flutter extension creates a plan before editing, which avoids mistakes
4. **Review generated code** — Gemini is good but not perfect. Check logic, null safety, and edge cases
5. **Commit often** — Use `/commit` for clean conventional commit messages

---

## License

MIT — do whatever you want with it.
