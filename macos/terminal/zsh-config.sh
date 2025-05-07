#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

configure_zsh() {
    print_status "Configuring ZSH..."

    # Install Oh My Zsh if not already installed
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        print_status "Oh My Zsh already installed"
    fi

    # Install additional plugins
    print_status "Installing additional ZSH plugins..."
    
    # Install zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        print_status "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    else
        print_status "zsh-autosuggestions already installed"
    fi

    # Install zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        print_status "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
        print_status "zsh-syntax-highlighting already installed"
    fi

    # Update .zshrc with our configuration
    cat > "$HOME/.zshrc" << 'EOF'
# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="muse"

# Which plugins would you like to load?
plugins=(alias-finder colored-man-pages copypath dirhistory docker extract fzf github git history-substring-search jsontools macos npm sudo thefuck web-search yarn z zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8
export EDITOR='nvim'

# Aliases
alias vim=nvim
alias vi=nvim
alias v=nvim
alias lg=lazygit
alias zshconfig="v ~/.zshrc"
alias ohmyzsh="v ~/.oh-my-zsh"

# Add Homebrew to PATH
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# Setup Homebrew completions
if type brew &>/dev/null; then
    # Add Homebrew's site-functions to FPATH
    if [ -d "$(brew --prefix)/share/zsh/site-functions" ]; then
        FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
    fi
    
    # Add Homebrew's main completions
    if [ -d "$(brew --prefix)/Homebrew/completions/zsh" ]; then
        FPATH="$(brew --prefix)/Homebrew/completions/zsh:$FPATH"
    fi
    
    # Initialize completions
    autoload -Uz compinit
    compinit
fi
EOF

    print_status "ZSH configuration complete!"
    print_status "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
}

# Main execution
configure_zsh 