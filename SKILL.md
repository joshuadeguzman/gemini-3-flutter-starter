---
name: flutter-gemini-charter
description: "Generate GEMINI.md project charter files for Flutter projects that configure Gemini CLI behavior. Use this skill whenever the user mentions 'GEMINI.md', 'Gemini CLI', 'Gemini charter', 'project charter for Gemini', or wants to create a configuration/context file that an AI coding agent reads from the project root. Also trigger when the user asks to scaffold a Flutter project with AI-assisted development setup, generate coding standards or conventions files for Flutter/Dart, create a development blueprint or ruleset for an AI pair programmer, or bootstrap a new Flutter app with Gemini CLI workflows including starter prompts, setup scripts, or README files. Trigger even if the user says 'rules file', 'context file', 'project instructions', 'coding guidelines', or 'AI config' in a Flutter context. Do NOT trigger for general Flutter coding questions, Firebase setup, or Gemini API integration (the AI SDK) — this skill is specifically about the GEMINI.md configuration file and surrounding developer workflow files."
---

# Flutter GEMINI.md Charter Generator

Generate production-ready `GEMINI.md` project charter files that configure Gemini CLI for Flutter/Dart development, along with optional companion files (starter prompts, setup scripts, READMEs).

## What This Skill Produces

| File | Purpose | When to Generate |
|------|---------|-----------------|
| `GEMINI.md` | Project charter — Gemini CLI reads this from project root and follows its directives | Always |
| `STARTER_PROMPT.md` | Copy-paste prompt to bootstrap the app in Gemini CLI | When user wants a kickstart prompt |
| `setup.sh` | One-command script to install Gemini CLI + create Flutter project + copy charter | When user wants repo automation |
| `README.md` | Repo documentation with setup instructions and usage guide | When user wants a distributable starter kit |

## Before You Begin

1. **Gather project context.** Ask the user (or infer from conversation) the specifics below. Don't generate until you know enough to make the charter useful and specific — a generic charter is a wasted charter.
2. **If the user provides minimal info**, ask targeted questions. If they say "just make one for my app", extract what you can from memory and conversation history, then confirm assumptions before generating.

### Key Inputs to Gather

| Input | Why It Matters | Default If Unknown |
|-------|---------------|-------------------|
| App name & description | Sets project identity and scope | Ask — don't guess |
| Platform targets | Constrains platform-specific advice | `android, ios` |
| State management | Drives architecture section | `ChangeNotifier + Provider` |
| Persistence strategy | In-memory, local DB, Firebase, etc. | Ask — major architectural decision |
| Design system | Material 3, Cupertino, custom | `Material 3 (useMaterial3: true)` |
| Icon source | Material Icons, Cupertino, packages | `Material Icons only` |
| Visual direction | Minimalist, playful, corporate, etc. | `Clean minimalist` |
| Navigation approach | go_router, auto_route, Navigator 2.0 | `go_router` |
| Backend/services | Firebase, Supabase, REST API, none | Ask if unclear |
| Testing expectations | Unit, widget, integration, none | Unit + widget tests |
| Existing conventions | Linting rules, team preferences | Effective Dart defaults |

## Charter Structure

Every GEMINI.md must include these sections in order. Omit sections only if genuinely irrelevant to the project.

```
# GEMINI.md — [App Name] Development Charter

## Project Overview
  - Project name, description, platforms, SDK versions

## General Instructions
  - Role definition ("You are an expert Flutter/Dart developer...")
  - Code style baseline (Effective Dart)
  - Null safety, const usage, doc comments
  - Communication preferences (concise, show diffs, ask before assuming)

## Design Philosophy (if UI-facing app)
  - Visual direction and design system
  - Icon policy
  - Typography, color, spacing rules
  - Animation guidelines
  - Dark mode support
  - Empty state and loading state expectations

## Architecture & State Management
  - Pattern (feature-first, clean arch, MVC, etc.)
  - State management solution with rationale
  - Full folder structure as ASCII tree
  - Separation of concerns rules

## Data & Persistence
  - Storage strategy with explicit constraints
  - Data model conventions (immutability, copyWith, serialization)
  - Example model pattern in code

## Coding Style & Conventions
  - Naming table (files, classes, variables, constants, privates)
  - Widget guidelines (extraction thresholds, const, Key params)
  - Dart best practices (final, switch expressions, patterns, extensions)

## Navigation
  - Router choice and route definition conventions

## Testing
  - What to test, mocking library, file structure, naming

## Performance
  - Build optimization rules, animation defaults

## Git Conventions
  - Commit format, atomicity rules

## Forbidden Patterns
  - Explicit ❌ list of anti-patterns to avoid

## Project-Specific Notes
  - App-specific context (APIs, monetization, analytics, future plans)
```

## Writing Principles

### Be Prescriptive, Not Descriptive
The charter tells Gemini CLI what to DO, not what Flutter is. Every line should be an actionable directive.

**Bad:** "Flutter supports both Material and Cupertino design systems."
**Good:** "Use Material 3 with `useMaterial3: true`. Do NOT use Cupertino widgets."

### Be Opinionated
A charter that says "use any state management solution" is useless. Pick one approach and enforce it. The user chose you to make decisions — make them.

**Bad:** "You can use Provider, Riverpod, or Bloc for state management."
**Good:** "State Management: Riverpod with code generation. No Bloc, no raw Provider."

### Include Concrete Examples
Especially for data models and architectural patterns. A 10-line code example communicates more than 10 lines of prose.

### Use the Forbidden Patterns Section Aggressively
Gemini CLI models tend to reach for common patterns that may not fit the project. Explicitly ban what you don't want. Format as `❌` items for visual scanning.

### Keep It Under 300 Lines
A charter that's too long gets diluted. If you need more detail on a specific domain (e.g., a complex design system), put it in a separate reference file and point to it from the charter.

## Generating Companion Files

### STARTER_PROMPT.md

When generating a starter prompt:

1. **Structure it as a single code block** the user can copy-paste into Gemini CLI
2. **Start with a one-line app description** followed by `## Technical Requirements` listing the stack
3. **Define screens and features** with enough detail that Gemini can build them without follow-up questions — include widget hierarchy, data displayed, user interactions, and edge states
4. **Specify seed/demo data** so the app never starts empty
5. **End with a build order** — which screen first, what to test at each step
6. **Reference the GEMINI.md** — mention that Gemini should follow the charter for style, architecture, and conventions

The prompt should be detailed enough that Gemini CLI can generate a working app in one session with minimal back-and-forth.

### setup.sh

When generating a setup script:

1. **Check prerequisites** — Flutter SDK, Node.js 20+, Git
2. **Install Gemini CLI** globally via npm (skip if already installed)
3. **Check authentication** — detect `GEMINI_API_KEY` env var, warn if missing
4. **Create Flutter project** — `flutter create --empty <name> --platforms=<targets>`
5. **Copy GEMINI.md** into the project root
6. **Optionally install the Flutter extension** — `gemini extensions install flutter`
7. **Initialize git** with a clean first commit
8. **Print next steps** — cd, gemini, paste prompt

Important: Flutter project names must use `snake_case` (no hyphens). Repo names can use hyphens.

### README.md

When generating a README:

1. **One-line description** of what the repo is
2. **What's Inside** — table of files and their purposes
3. **Prerequisites** — Flutter, Node.js, Git with version check commands
4. **Quick Start** — clone, run setup.sh, paste prompt (3 steps)
5. **Manual Setup** — step-by-step alternative for those who prefer control
6. **Flutter Extension section** — optional but recommended
7. **Project Structure** — ASCII tree of what the generated app will look like
8. **Customization guide** — how to tweak the charter for evolving needs
9. **Tips for working with Gemini CLI** — practical advice

## Quality Checklist

Before presenting the charter to the user, verify:

- [ ] Every section contains actionable directives, not descriptions
- [ ] State management is a single explicit choice
- [ ] Persistence strategy is clearly constrained
- [ ] Folder structure is a complete ASCII tree
- [ ] At least one code example is included (model pattern)
- [ ] Forbidden patterns section has 7+ items
- [ ] No generic filler — every line earns its place
- [ ] Design section (if present) specifies color, spacing, typography, and animation
- [ ] File is under 300 lines
- [ ] Communication style section tells Gemini how to talk to the user
- [ ] Project-specific notes capture what makes this app unique

## Edge Cases

- **User wants a global charter (~/.gemini/GEMINI.md):** Generate a slimmer version with only language-level conventions (Dart style, null safety, testing, git) and no app-specific sections. Note that project-root charters override globals.
- **User already has a GEMINI.md and wants updates:** Read the existing file first, identify gaps against the structure above, and propose targeted additions rather than rewriting from scratch.
- **User wants charter for a package (not an app):** Adjust architecture section for library structure (`src/`, `lib/`, `example/`), remove navigation/design sections, add pub.dev publishing conventions.
- **User wants charter for a monorepo:** Add workspace/package-level conventions, shared dependencies, and cross-package import rules.
