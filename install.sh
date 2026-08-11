#!/usr/bin/env bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==>${NC} ${GREEN}Starting agy-tmux installation...${NC}"

# Configure sudo wrapper
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    if command -v sudo &> /dev/null; then
        SUDO="sudo"
    fi
fi

# Detect installation directory
BIN_DIR="/usr/local/bin"
if [ -n "$PREFIX" ] && [ -d "$PREFIX/bin" ]; then
    BIN_DIR="$PREFIX/bin"
fi

install_package() {
    local pkg=$1
    if command -v pkg &> /dev/null; then
        pkg install -y "$pkg" >/dev/null 2>&1
    elif command -v apt-get &> /dev/null; then
        $SUDO apt-get update >/dev/null 2>&1
        $SUDO apt-get install -y "$pkg" >/dev/null 2>&1
    elif command -v dnf &> /dev/null; then
        $SUDO dnf install -y "$pkg" >/dev/null 2>&1
    elif command -v yum &> /dev/null; then
        $SUDO yum install -y "$pkg" >/dev/null 2>&1
    elif command -v pacman &> /dev/null; then
        $SUDO pacman -Sy --noconfirm "$pkg" >/dev/null 2>&1
    elif command -v apk &> /dev/null; then
        $SUDO apk add "$pkg" >/dev/null 2>&1
    elif command -v brew &> /dev/null; then
        brew install "$pkg" >/dev/null 2>&1
    fi
}

# Check for tmux
echo -ne "  -> Checking for tmux... "
if ! command -v tmux &> /dev/null; then
    echo -e "${BLUE}Installing tmux...${NC}"
    install_package tmux
    if ! command -v tmux &> /dev/null; then
        echo -e "${RED}Failed to install tmux!${NC}"
        echo "     Please install tmux manually and try again."
        exit 1
    fi
fi
echo -e "${GREEN}OK${NC}"

# Download and install gem
echo -ne "  -> Installing gem script... "

curl -fsSL https://raw.githubusercontent.com/zenyxx-xd/Antigravity-CLI-tmux/main/gem -o /tmp/gem
$SUDO mv /tmp/gem "${BIN_DIR}/gem"
$SUDO chmod +x "${BIN_DIR}/gem"

echo -e "${GREEN}Done!${NC}"
echo ""
echo -e "${BLUE}Installation successful!${NC}"
echo -e "You can now run ${GREEN}gem${NC} from anywhere."
echo -e "For more options, try: ${GREEN}gem -h${NC}"
