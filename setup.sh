#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Habit Tracking App — Gemini CLI Starter Setup
# ============================================================
# This script:
#   1. Checks prerequisites (Flutter, Node.js, Git)
#   2. Installs Gemini CLI globally (if not installed)
#   3. Creates the Flutter project
#   4. Copies GEMINI.md into the project
#   5. Installs the Flutter extension for Gemini CLI (optional)
#   6. Opens a Gemini CLI session in the project directory
# ============================================================

PURPLE='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

PROJECT_NAME="habit_tracking_app"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_step() {
    echo -e "\n${PURPLE}▸${NC} ${BOLD}$1${NC}"
}

print_success() {
    echo -e "  ${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "  ${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "  ${RED}✗${NC} $1"
}

# --------------------------------------------------
# 1. Check prerequisites
# --------------------------------------------------
print_step "Checking prerequisites..."

if ! command -v flutter &> /dev/null; then
    print_error "Flutter not found. Install it from https://docs.flutter.dev/get-started/install"
    exit 1
fi
print_success "Flutter $(flutter --version 2>&1 | head -n 1 | awk '{print $2}')"

if ! command -v node &> /dev/null; then
    print_error "Node.js not found. Install v20+ from https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node --version | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    print_error "Node.js v20+ required. Current: $(node --version)"
    exit 1
fi
print_success "Node.js $(node --version)"

if ! command -v git &> /dev/null; then
    print_error "Git not found. Install it from https://git-scm.com/"
    exit 1
fi
print_success "Git $(git --version | awk '{print $3}')"

# --------------------------------------------------
# 2. Install Gemini CLI
# --------------------------------------------------
print_step "Setting up Gemini CLI..."

if command -v gemini &> /dev/null; then
    print_success "Gemini CLI already installed"
else
    echo "  Installing Gemini CLI globally..."
    npm install -g @google/gemini-cli
    print_success "Gemini CLI installed"
fi

# --------------------------------------------------
# 3. Check authentication
# --------------------------------------------------
print_step "Checking authentication..."

if [ -n "${GEMINI_API_KEY:-}" ]; then
    print_success "GEMINI_API_KEY environment variable detected"
else
    print_warning "No GEMINI_API_KEY found — Gemini will prompt for Google sign-in on first run"
    echo "         To use an API key instead, run:"
    echo "         export GEMINI_API_KEY=\"your-key-from-aistudio.google.com\""
fi

# --------------------------------------------------
# 4. Create Flutter project
# --------------------------------------------------
print_step "Creating Flutter project '${PROJECT_NAME}'..."

if [ -d "$PROJECT_NAME" ]; then
    print_warning "Directory '${PROJECT_NAME}/' already exists — skipping project creation"
else
    flutter create --empty "$PROJECT_NAME" --platforms=android,ios
    print_success "Flutter project created"
fi

# --------------------------------------------------
# 5. Copy GEMINI.md into project
# --------------------------------------------------
print_step "Copying GEMINI.md into project..."

if [ -f "$SCRIPT_DIR/GEMINI.md" ]; then
    cp "$SCRIPT_DIR/GEMINI.md" "$PROJECT_NAME/GEMINI.md"
    print_success "GEMINI.md copied to ${PROJECT_NAME}/"
else
    print_error "GEMINI.md not found in ${SCRIPT_DIR}. Make sure it exists next to this script."
    exit 1
fi

# --------------------------------------------------
# 6. Install Flutter extension (optional)
# --------------------------------------------------
print_step "Installing Flutter extension for Gemini CLI..."

if gemini extensions list 2>/dev/null | grep -q "flutter"; then
    print_success "Flutter extension already installed"
else
    read -rp "  Install the Flutter extension for Gemini CLI? (y/N): " INSTALL_EXT
    if [[ "$INSTALL_EXT" =~ ^[Yy]$ ]]; then
        gemini extensions install flutter
        print_success "Flutter extension installed"
    else
        print_warning "Skipped — you can install later with: gemini extensions install flutter"
    fi
fi

# --------------------------------------------------
# 7. Initialize git
# --------------------------------------------------
print_step "Initializing Git repository..."

cd "$PROJECT_NAME"

if [ -d ".git" ]; then
    print_success "Git repo already initialized"
else
    git init
    git add .
    git commit -m "chore: initial Flutter project with GEMINI.md charter"
    print_success "Git initialized with initial commit"
fi

# --------------------------------------------------
# Done!
# --------------------------------------------------
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  ✓ Habit Tracking App project is ready!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${BOLD}Next steps:${NC}"
echo ""
echo -e "  1. cd ${PROJECT_NAME}"
echo -e "  2. gemini"
echo -e "  3. Paste the prompt from STARTER_PROMPT.md"
echo ""
echo -e "  ${PURPLE}Happy building! 🚀${NC}"
echo ""
