#!/bin/bash
# finishup/verify.sh
#
# Final verification and recap for dev machine setup.
# Checks installed tools, ensures env vars, and prints a summary.

print_status() { echo -e "\033[1;32m[*]\033[0m $1"; }
print_warning() { echo -e "\033[1;33m[!]\033[0m $1"; }

BREW_PREFIX="$(brew --prefix)"
ZSHRC="$HOME/.zshrc"

# Helper to ensure an export is in ~/.zshrc
ensure_export() {
  local var="$1"
  local value="$2"
  grep -q "$var" "$ZSHRC" || echo "export $var=\"$value:\$$var\"" >> "$ZSHRC"
  export $var="$value:${!var}"
}

print_status "Verifying Homebrew, pyenv, Volta, and core tools..."

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  print_warning "Homebrew not found!"
else
  print_status "Homebrew installed."
fi

# pyenv
if ! command -v pyenv >/dev/null 2>&1; then
  print_warning "pyenv not found!"
else
  print_status "pyenv installed."
fi

# Volta
if ! command -v volta >/dev/null 2>&1; then
  print_warning "Volta not found!"
else
  print_status "Volta installed."
  ensure_export VOLTA_HOME "$HOME/.volta"
  ensure_export PATH "$HOME/.volta/bin:$PATH"
fi

# vips
if brew list vips &>/dev/null; then
  print_status "libvips installed."
  ensure_export CPLUS_INCLUDE_PATH "$BREW_PREFIX/include"
  ensure_export LIBRARY_PATH "$BREW_PREFIX/lib"
  ensure_export PKG_CONFIG_PATH "$BREW_PREFIX/lib/pkgconfig"
else
  print_warning "libvips not found!"
fi

# Python
if command -v python3 >/dev/null 2>&1; then
  print_status "Python 3 available: $(python3 --version)"
else
  print_warning "Python 3 not found!"
fi

# Node
if command -v node >/dev/null 2>&1; then
  print_status "Node.js available: $(node --version)"
else
  print_warning "Node.js not found!"
fi

# Docker
if command -v docker >/dev/null 2>&1; then
  print_status "Docker installed."
else
  print_warning "Docker not found!"
fi

# Print summary
print_status "Verification complete."
print_status "If you see any warnings above, review your setup or re-run the relevant category script."
print_status "You may need to restart your terminal or run 'source ~/.zshrc' to apply new environment variables."

# --- ZSHRC BACKUP ---
if [ -f "$ZSHRC" ]; then
  TS=$(date +%Y%m%d-%H%M%S)
  cp "$ZSHRC" "$ZSHRC.backup-$TS"
  print_status "Backed up .zshrc to $ZSHRC.backup-$TS"
fi

# --- C++/Native Build Env Vars ---
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