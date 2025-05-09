#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

install_xcode() {
    print_status "Checking for Xcode Command Line Tools..."
    if ! command_exists xcode-select; then
        print_status "Installing Xcode Command Line Tools..."
        xcode-select --install
    else
        print_status "Xcode Command Line Tools already installed"
    fi
}

install_homebrew() {
    print_status "Checking for Homebrew..."
    if ! command_exists brew; then
        print_status "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add Homebrew to PATH
        if [[ -f ~/.zprofile ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        fi
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        print_status "Homebrew already installed"
    fi
}

install_python() {
    print_status "Checking for Python installations..."
    
    # Install pyenv if not present
    if ! command_exists pyenv; then
        print_status "Installing pyenv..."
        brew install pyenv
        # Add pyenv to shell
        if [[ -f ~/.zshrc ]]; then
            echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
            echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
            echo 'eval "$(pyenv init -)"' >> ~/.zshrc
        fi
        # Reload shell configuration
        eval "$(pyenv init -)"
    fi
    
    # Install Python 2.7.18 (last 2.7 release) if not present
    if ! pyenv versions | grep -q "2.7.18"; then
        print_status "Installing Python 2.7.18..."
        pyenv install 2.7.18
    fi
    
    # Install Python 3.11 if not present
    if ! pyenv versions | grep -q "3.11"; then
        print_status "Installing Python 3.11..."
        pyenv install 3.11.7
    fi
    
    # Set Python 2.7.18 as the default 'python' command
    print_status "Setting Python 2.7.18 as default..."
    pyenv global 2.7.18
    
    # Set npm_config_python to point to Python 2.7
    print_status "Configuring npm to use Python 2.7..."
    if [[ -f ~/.zshrc ]] && ! grep -q "npm_config_python" ~/.zshrc; then
        echo 'export npm_config_python="$(pyenv which python)"' >> ~/.zshrc
    fi
    
    # Install pip for Python 2.7 if not present
    if ! command_exists pip; then
        print_status "Installing pip for Python 2.7..."
        curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
        python get-pip.py
        rm get-pip.py
    fi
    
    # Install required packages for Python 2.7
    print_status "Installing Python 2.7 packages..."
    pip install --upgrade setuptools wheel
}

install_volta() {
    print_status "Installing Volta..."
    if ! command_exists volta; then
        curl https://get.volta.sh | bash
        
        # Add Volta to PATH for current shell
        export VOLTA_HOME="$HOME/.volta"
        export PATH="$VOLTA_HOME/bin:$PATH"
        
        # Add Volta to shell configuration
        if [[ -f ~/.zshrc ]]; then
            if ! grep -q "VOLTA_HOME" ~/.zshrc; then
                echo 'export VOLTA_HOME="$HOME/.volta"' >> ~/.zshrc
                echo 'export PATH="$VOLTA_HOME/bin:$PATH"' >> ~/.zshrc
            fi
        fi
    else
        print_status "Volta already installed"
    fi
}

# Ensure jq is installed
if ! command_exists jq; then
    print_status "Installing jq..."
    brew install jq
else
    print_status "jq already installed"
fi

# Main execution
install_xcode
install_homebrew
install_python
install_volta

print_status "Baseline setup complete!"
print_status "Please ensure Xcode Command Line Tools installation is complete before proceeding with other components."
print_status "Note: You may need to restart your terminal or run 'source ~/.zshrc' to fully initialize Volta." 