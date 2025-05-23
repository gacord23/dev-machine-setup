# Development Machine Setup

This repository contains scripts to automate the setup of development environments across macOS, Linux, and Windows. It helps you install and configure common development tools, IDEs, and utilities with a simple menu-driven interface.

## Features

- Cross-platform support (macOS, Linux, Windows)
- Modular installation of development tools
- Easy uninstallation of components
- Consistent setup across machines
- Support for:
  - Git tools (Git, LazyGit, GitHub CLI, Git LFS)
  - Docker (Docker Desktop/Engine, Colima)
  - IDEs (VSCode, Cursor, WebStorm, LazyVim)
  - Terminal tools (iTerm2, Warp, oh-my-zsh)
  - And more...

## Quick Start

### macOS/Linux

1. Run the setup script:
   ```bash
   ./setup.sh
   ```

2. To uninstall components:
   ```bash
   ./setup.sh -u
   ```

### Windows

1. Run the setup script:
   ```powershell
   .\setup.ps1
   ```

2. To uninstall components:
   ```powershell
   .\setup.ps1 -Uninstall
   ```

## What Gets Installed

### Baseline Tools
- Package managers (Homebrew, apt, Chocolatey)
- Build essentials
- Common utilities

### Git Tools
- Git
- LazyGit
- GitHub CLI
- Git LFS
- GitKraken

### Docker
- Docker Desktop (macOS/Windows)
- Docker Engine (Linux)
- Colima (macOS/Linux)
- Kubernetes tools

### IDEs and Editors
- VSCode
- Cursor
- WebStorm
- LazyVim
- IntelliJ IDEA
- PyCharm
- Sublime Text

### Terminal Tools
- iTerm2 (macOS)
- Warp (macOS)
- Windows Terminal (Windows)
- oh-my-zsh
- Custom shell configurations

## Contributing

Feel free to submit issues and enhancement requests! 