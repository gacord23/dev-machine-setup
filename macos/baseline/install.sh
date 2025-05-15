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
    
    # --- Undo previous Python 2.7 global default and npm_config_python changes ---
    print_status "Checking for previous Python 2.7 global default or npm_config_python..."

    # If pyenv global is set to 2.7.18, reset to 3.11.7
    if pyenv global | grep -q "2.7.18"; then
        print_status "Resetting pyenv global from 2.7.18 to 3.11.7..."
        pyenv global 3.11.7
        eval "$(pyenv init -)"
        pyenv rehash
    fi

    # Remove npm_config_python lines from ~/.zshrc that point to Python 2.7
    if [[ -f ~/.zshrc ]]; then
        sed -i.bak '/npm_config_python/d' ~/.zshrc
    fi

    # Optionally remove user-local symlink for python -> python2.7 if it exists
    if [[ -L /usr/local/bin/python ]] && [[ "$(readlink /usr/local/bin/python)" == *"2.7"* ]]; then
        print_status "Removing user-local symlink for python -> python2.7..."
        sudo rm /usr/local/bin/python
    fi

    # --- Install pyenv and Python versions as before ---
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
    
    # Install Python 3.11 if not present
    if ! pyenv versions | grep -q "3.11"; then
        print_status "Installing Python 3.11..."
        pyenv install 3.11.7
    fi
    
    # Find the latest installed Python 3.x version
    latest_py3=$(pyenv versions --bare | grep '^3\.' | sort -V | tail -n 1)
    if [ -n "$latest_py3" ]; then
        print_status "Setting Python $latest_py3 as default..."
        pyenv global "$latest_py3"
        eval "$(pyenv init -)"
        pyenv rehash
    else
        print_status "No Python 3.x version found in pyenv!"
    fi
    
    # Ensure pip3 and setuptools (for distutils) are installed for Python 3
    if command -v python3 >/dev/null 2>&1; then
        print_status "Upgrading pip and setuptools for Python 3..."
        python3 -m pip install --upgrade pip setuptools
    fi

    # Ensure setuptools (and thus distutils) is installed for the default python
    if command -v python >/dev/null 2>&1; then
        print_status "Upgrading pip and setuptools for Python (default python)..."
        python -m pip install --upgrade pip setuptools
    fi

    # Set npm_config_python to point to python3 in ~/.zshrc
    if [[ -f ~/.zshrc ]] && ! grep -q "npm_config_python" ~/.zshrc; then
        echo 'export npm_config_python="$(pyenv which python3)"' >> ~/.zshrc
    fi

    # --- (Optional) Legacy Python 2.7 support ---
    # To use Python 2.7 for legacy projects, run:
    #   pyenv shell 2.7.18
    #   export npm_config_python="$(pyenv root)/versions/2.7.18/bin/python"
    # This will temporarily set Python 2.7 for your shell session.

    # --- Remove forced 2.7 global default and npm_config_python export ---
    # (No longer setting Python 2.7 as global or exporting npm_config_python by default)

    # Ensure pyenv shims are first in PATH in ~/.zshrc
    if [[ -f ~/.zshrc ]] && ! grep -q 'pyenv/shims' ~/.zshrc; then
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
        echo 'export PATH="$PYENV_ROOT/shims:$PATH"' >> ~/.zshrc
    fi
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/shims:$PATH"

    # Create or update the python shim to point to python3
    if command -v python3 >/dev/null 2>&1; then
        ln -sf "$(pyenv which python3)" "$PYENV_ROOT/shims/python"
        pyenv rehash
    fi
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

# Ensure libvips is installed for sharp and similar modules
print_status "Ensuring libvips is installed via Homebrew..."
if ! brew list vips &>/dev/null; then
    brew install vips
else
    print_status "libvips already installed"
fi

# --- ZSHRC BACKUP ---
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
  TS=$(date +%Y%m%d-%H%M%S)
  cp "$ZSHRC" "$ZSHRC.backup-$TS"
  print_status "Backed up .zshrc to $ZSHRC.backup-$TS"
fi

# --- C++/Native Build Env Vars ---
BREW_PREFIX="$(brew --prefix)"
GLIB_PREFIX="$(brew --prefix glib 2>/dev/null || echo "$BREW_PREFIX")"
VIPS_PREFIX="$(brew --prefix vips 2>/dev/null || echo "$BREW_PREFIX")"
GLIB_INCLUDE1="$GLIB_PREFIX/include/glib-2.0"
GLIB_INCLUDE2="$GLIB_PREFIX/lib/glib-2.0/include"
VIPS_INCLUDE="$VIPS_PREFIX/include"

export CPLUS_INCLUDE_PATH="$GLIB_INCLUDE1:$GLIB_INCLUDE2:$VIPS_INCLUDE:$BREW_PREFIX/include${CPLUS_INCLUDE_PATH:+:$CPLUS_INCLUDE_PATH}"
export LIBRARY_PATH="$BREW_PREFIX/lib${LIBRARY_PATH:+:$LIBRARY_PATH}"
export PKG_CONFIG_PATH="$BREW_PREFIX/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
export CXXFLAGS="-I$GLIB_INCLUDE1 -I$GLIB_INCLUDE2 -I$VIPS_INCLUDE -I$BREW_PREFIX/include ${CXXFLAGS:-}"
export LDFLAGS="-L$BREW_PREFIX/lib ${LDFLAGS:-}"

append_if_missing() {
  local var="$1"
  local value="$2"
  grep -q "$value" "$ZSHRC" || echo "export $var=\"$value:\$$var\"" >> "$ZSHRC"
}
append_if_missing CPLUS_INCLUDE_PATH "$GLIB_INCLUDE1"
append_if_missing CPLUS_INCLUDE_PATH "$GLIB_INCLUDE2"
append_if_missing CPLUS_INCLUDE_PATH "$VIPS_INCLUDE"
append_if_missing CPLUS_INCLUDE_PATH "$BREW_PREFIX/include"
append_if_missing LIBRARY_PATH "$BREW_PREFIX/lib"
append_if_missing PKG_CONFIG_PATH "$BREW_PREFIX/lib/pkgconfig"
append_if_missing CXXFLAGS "-I$GLIB_INCLUDE1 -I$GLIB_INCLUDE2 -I$VIPS_INCLUDE -I$BREW_PREFIX/include"
append_if_missing LDFLAGS "-L$BREW_PREFIX/lib"

# Main execution
install_xcode
install_homebrew
install_python
install_volta

print_status "Baseline setup complete!"
print_status "Please ensure Xcode Command Line Tools installation is complete before proceeding with other components."
print_status "Note: You may need to restart your terminal or run 'source ~/.zshrc' to fully initialize Volta." 