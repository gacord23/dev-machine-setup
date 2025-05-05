#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

install_iterm2() {
    print_status "Installing iTerm2..."
    if ! command_exists iterm2; then
        brew install --cask iterm2
    else
        print_status "iTerm2 already installed"
    fi
}

install_warp() {
    print_status "Installing Warp..."
    if ! command_exists warp; then
        brew install --cask warp
    else
        print_status "Warp already installed"
    fi
}

configure_zsh() {
    print_status "Installing and configuring zsh..."
    if ! command_exists zsh; then
        brew install zsh
    fi

    # Install oh-my-zsh if not already installed
    if [ ! -d ~/.oh-my-zsh ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        # Install zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        # Install zsh-syntax-highlighting
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        # Update .zshrc with plugins
        sed -i '' 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
    else
        print_status "oh-my-zsh already installed"
    fi
}

# Main execution
print_status "Select your preferred terminal:"
echo "1) iTerm2"
echo "2) Warp"
echo "3) None"
read -p "Enter your choice (1-3): " terminal_choice

case $terminal_choice in
    1)
        install_iterm2
        ;;
    2)
        install_warp
        ;;
    3)
        print_status "Skipping terminal installation"
        ;;
    *)
        print_error "Invalid choice. Skipping terminal installation."
        ;;
esac

if prompt_yes_no "Would you like to configure zsh with oh-my-zsh?"; then
    configure_zsh
fi

print_status "Terminal setup complete!"
print_status "Please restart your terminal to apply zsh changes"
print_status "You can verify zsh is your default shell with: echo $SHELL"
print_status "If zsh is not your default shell, run: chsh -s $(which zsh)" 