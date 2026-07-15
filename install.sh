#!/usr/bin/env bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==>${NC} ${GREEN}Starting agy-tmux installation...${NC}"

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
fi

# Check for tmux
echo -ne "  -> Checking for tmux... "
if ! command -v tmux &> /dev/null; then
    echo -e "${BLUE}Installing tmux...${NC}"
    $SUDO apt-get update >/dev/null 2>&1
    $SUDO apt-get install -y tmux >/dev/null 2>&1
    if ! command -v tmux &> /dev/null; then
        echo -e "${RED}Failed to install tmux!${NC}"
        echo "     Please install tmux manually (e.g. apt install tmux) and try again."
        exit 1
    fi
fi
echo -e "${GREEN}OK${NC}"

# Check for python3
echo -ne "  -> Checking for python3... "
if ! command -v python3 &> /dev/null || ! command -v pip3 &> /dev/null && ! command -v pip &> /dev/null; then
    echo -e "${BLUE}Installing python3 and pip...${NC}"
    $SUDO apt-get update >/dev/null 2>&1
    $SUDO apt-get install -y python3 python3-pip python3-venv >/dev/null 2>&1
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}Failed to install python3!${NC}"
        echo "     Please install python3 manually (e.g. apt install python3 python3-pip) and try again."
        exit 1
    fi
fi
echo -e "${GREEN}OK${NC}"

# Check/install mitmproxy (required for region bypass)
echo -ne "  -> Checking for mitmdump (mitmproxy)... "
if ! command -v mitmdump &> /dev/null; then
    PIP_CMD=$(command -v pip3 || command -v pip)
    if [ -n "$PIP_CMD" ]; then
        $PIP_CMD install --break-system-packages mitmproxy 2>/dev/null || $PIP_CMD install mitmproxy 2>/dev/null
    fi
    if ! command -v mitmdump &> /dev/null; then
        echo -e "${RED}Not found / installation failed!${NC}"
        echo "     Please install mitmproxy manually (pip install --break-system-packages mitmproxy) and try again."
        exit 1
    fi
fi
echo -e "${GREEN}OK${NC}"

# Download and install gem
echo -ne "  -> Installing gem script... "

# Use local gem if running inside cloned repo, otherwise fetch from GitHub
if [ -f "$(dirname "$0")/gem" ]; then
    $SUDO cp "$(dirname "$0")/gem" /usr/local/bin/gem
else
    BRANCH="${AGY_TMUX_BRANCH:-bypass}"
    curl -sL "https://raw.githubusercontent.com/tr1xx-tech/agy-tmux/${BRANCH}/gem" -o /tmp/gem
    $SUDO mv /tmp/gem /usr/local/bin/gem
fi

$SUDO chmod +x /usr/local/bin/gem

echo -e "${GREEN}Done!${NC}"
echo ""
echo -e "${BLUE}Installation successful!${NC}"
echo -e "You can now run ${GREEN}gem${NC} from anywhere."
echo -e "For more options, try: ${GREEN}gem -h${NC}"
