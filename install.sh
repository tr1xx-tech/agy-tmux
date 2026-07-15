#!/usr/bin/env bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==>${NC} ${GREEN}Starting agy-tmux installation...${NC}"

# Use sudo if we are not root
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
        echo "     Please install tmux manually and try again."
        exit 1
    fi
fi
echo -e "${GREEN}OK${NC}"

# Download and install gem
echo -ne "  -> Installing gem script... "

curl -sL https://raw.githubusercontent.com/tr1xx-tech/agy-tmux/main/gem -o /tmp/gem
$SUDO mv /tmp/gem /usr/local/bin/gem
$SUDO chmod +x /usr/local/bin/gem

echo -e "${GREEN}Done!${NC}"
echo ""
echo -e "${BLUE}Installation successful!${NC}"
echo -e "You can now run ${GREEN}gem${NC} from anywhere."
echo -e "For more options, try: ${GREEN}gem -h${NC}"
