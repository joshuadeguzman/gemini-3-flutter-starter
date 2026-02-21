# STARTER_PROMPT.md — Paste this into Gemini CLI to bootstrap Habit Tracking App

> Copy everything below the line and paste it as your first prompt in a Gemini CLI session inside the project directory.

---

```
Create a Flutter habit tracking app called "Habit Tracking App" with the following specifications:

## App Concept
A beautiful, minimalist habit tracker where users create daily habits, mark them complete with a satisfying tap, and build streaks. The UI should feel calm, clean, and motivating — not gamified or noisy.

## Technical Requirements
- Flutter with Material 3 (`useMaterial3: true`)
- State management: ChangeNotifier + Provider
- Data: In-memory only (no database, no SharedPreferences) — data resets on restart
- Icons: Material Icons only (`Icons.*`) — no third-party icon packages
- Navigation: go_router
- Dart 3+ features (patterns, sealed classes, switch expressions where appropriate)

## Screens & Features

### 1. Home Screen (Today View)
- App bar with greeting ("Good morning" / "Good afternoon" based on time) and today's date
- Summary card showing: habits completed today / total habits, and a circular progress ring
- Vertical list of habit cards, each showing:
  - Material icon (user-selected) with colored circular background
  - Habit name
  - Current streak count (e.g., "🔥 12 days")
  - Checkmark button on the right — tapping it marks the habit complete for today with a satisfying animation (scale + color transition)
  - Completed habits should have a subtle "done" visual state (muted colors, checkmark filled)
- FAB to add a new habit
- Empty state when no habits exist: icon, encouraging message, and "Create your first habit" button

### 2. Add/Edit Habit Screen
- Text field for habit name
- Icon picker: grid of 12-16 curated Material Icons relevant to habits (fitness, book, water, meditation, code, music, sleep, walk, food, brush, pet, heart, etc.)
- Color picker: row of 8-10 predefined colors (Material palette)
- Frequency selector: Daily (default), Weekdays, Weekends, Custom days
- Save button — validates that name is not empty
- If editing, pre-populate fields and show a delete option

### 3. Habit Detail Screen
- Large icon and habit name header
- Current streak (prominent display)
- Best streak (all-time)
- Monthly calendar heatmap or grid showing completed days (filled dots) vs missed days (empty dots) for the current month
- Completion rate percentage
- Edit and Delete actions

### 4. Stats/Summary Screen (optional tab)
- Overall completion rate across all habits
- Total active habits count
- Longest active streak
- Simple bar chart or visual showing completions per day for the past 7 days (can use a simple custom painter — no chart packages)

## Design Specifications
- Color: Use `ColorScheme.fromSeed(seedColor: Color(0xFF6C63FF))` — a calm purple
- Spacing: 4dp grid (constants: s4=4, s8=8, s12=12, s16=16, s24=24, s32=32)
- Cards: elevation 0-1, border radius 16, subtle surface tint
- Typography: Material 3 type scale, no custom fonts
- Animations: 300ms default with Curves.easeInOut — animated check marks, smooth progress ring transitions
- Support both light and dark themes
- Bottom navigation with 2-3 tabs: Today, Stats (optional), Settings

## Seed Data
On first launch, pre-populate with 4 demo habits so the app never starts empty:
1. "Exercise" — Icons.fitness_center — orange
2. "Read" — Icons.menu_book — blue
3. "Meditate" — Icons.self_improvement — purple
4. "Drink Water" — Icons.water_drop — cyan
Each should have a few random past completed dates to demonstrate streaks and the calendar view.

## File Structure
Follow the feature-first structure defined in GEMINI.md. Key folders:
- lib/app/ (theme, router, app widget)
- lib/core/ (constants, extensions, shared widgets)
- lib/features/habits/ (models, services, screens, widgets)
- lib/features/tracking/ (if separating tracking logic)
- lib/features/settings/ (theme toggle, about)

Start by creating the project structure, models, and the habit service with seed data. Then build the Home screen, then Add Habit, then Detail screen. Test each screen as you go.
```
