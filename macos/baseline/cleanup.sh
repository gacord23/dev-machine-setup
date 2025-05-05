#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

print_status "Cleaning up Python installations..."

# Remove Python 2.7 symlink if it exists
if [ -L "/usr/local/bin/python" ]; then
    print_status "Removing Python 2.7 symlink..."
    sudo rm /usr/local/bin/python
fi

# Uninstall Python 2.7 via Homebrew
if brew list python@2.7 &>/dev/null; then
    print_status "Uninstalling Python 2.7..."
    brew uninstall python@2.7
fi

# Remove pip installation
if [ -f "get-pip.py" ]; then
    print_status "Removing pip installation script..."
    rm get-pip.py
fi

print_status "Cleanup complete!"
print_status "You can now run the setup script again with the corrected Python installation." 