#!/bin/bash
# finishup/verify.sh (Linux)
#
# Final verification and recap for dev machine setup.
# Checks installed tools, ensures env vars, and prints a summary.

print_status() { echo -e "\033[1;32m[*]\033[0m $1"; }
print_warning() { echo -e "\033[1;33m[!]\033[0m $1"; }

ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
  TS=$(date +%Y%m%d-%H%M%S)
  cp "$ZSHRC" "$ZSHRC.backup-$TS"
  print_status "Backed up .zshrc to $ZSHRC.backup-$TS"
fi

# Helper to ensure an export is in ~/.zshrc
append_if_missing() {
  local var="$1"
  local value="$2"
  grep -q "$value" "$ZSHRC" || echo "export $var=\"$value:\$$var\"" >> "$ZSHRC"
}

# Check for essential development tools
check_command() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    print_status "$cmd installed."
  else
    print_warning "$cmd not found!"
  fi
}

# Check essential tools
check_command "git"
check_command "curl"
check_command "wget"
check_command "python3"
check_command "pip3"
check_command "node"
check_command "npm"
check_command "volta"

# Check for terminal emulators
check_command "gnome-terminal"
check_command "konsole"
check_command "alacritty"
check_command "kitty"

# Check for oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  print_status "oh-my-zsh installed."
else
  print_warning "oh-my-zsh not found!"
fi

# Check for zsh plugins
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  print_status "zsh-autosuggestions plugin installed."
else
  print_warning "zsh-autosuggestions plugin not found!"
fi

if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
  print_status "zsh-syntax-highlighting plugin installed."
else
  print_warning "zsh-syntax-highlighting plugin not found!"
fi

# Check for thefuck
if command -v thefuck >/dev/null 2>&1; then
  print_status "thefuck installed."
else
  print_warning "thefuck not found!"
fi

# Check for Nerd Fonts
if fc-list | grep -q "MesloLGM Nerd Font"; then
  print_status "MesloLGM Nerd Font installed."
else
  print_warning "MesloLGM Nerd Font not found!"
fi

# Print summary
print_status "Verification complete."
print_status "If you see any warnings above, review your setup or re-run the relevant category script."
print_status "You may need to restart your terminal or run 'source ~/.zshrc' to apply new environment variables." 