#!/bin/bash

# Source common utilities
source "$(dirname "$0")/../../common/utils.sh"

install_vips() {
    print_status "Checking for Vips..."
    if ! command_exists vips; then
        print_status "Installing Vips..."
        brew install vips
        print_status "Linking Vips..."
        brew link vips
    else
        print_status "Vips already installed"
        # Ensure it's linked even if already installed
        print_status "Ensuring Vips is properly linked..."
        brew link vips
    fi
}

install_glib() {
    print_status "Checking for glib..."
    if ! command_exists glib-compile-resources; then
        print_status "Installing glib..."
        brew install glib
    else
        print_status "glib already installed"
    fi
}

configure_shell() {
    print_status "Configuring shell for imaging tools..."
    
    # Create a backup of .zshrc
    if [ -f ~/.zshrc ]; then
        cp ~/.zshrc ~/.zshrc.bak
        print_status "Created backup of .zshrc at ~/.zshrc.bak"
    fi
    
    # Get Vips version and path
    VIPS_VERSION=$(brew list --versions vips | awk '{print $2}')
    VIPS_PATH="/opt/homebrew/Cellar/vips/${VIPS_VERSION}"
    
    # Get glib version and path
    GLIB_VERSION=$(brew list --versions glib | awk '{print $2}')
    GLIB_PATH="/opt/homebrew/Cellar/glib/${GLIB_VERSION}"
    
    # Add PKG_CONFIG_PATH for glib
    if ! grep -q "PKG_CONFIG_PATH=\"/usr/local/lib/pkgconfig\"" ~/.zshrc; then
        echo 'export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"' >> ~/.zshrc
    fi
    
    if ! grep -q "PKG_CONFIG_PATH=\"${GLIB_PATH}/lib/pkgconfig:\$PKG_CONFIG_PATH\"" ~/.zshrc; then
        echo "export PKG_CONFIG_PATH=\"${GLIB_PATH}/lib/pkgconfig:\$PKG_CONFIG_PATH\"" >> ~/.zshrc
    fi
    
    # Add CXXFLAGS for glib and vips
    if ! grep -q "CXXFLAGS=\"-I${GLIB_PATH}/include/glib-2.0 -I${GLIB_PATH}/lib/glib-2.0/include -I${VIPS_PATH}/include\"" ~/.zshrc; then
        echo "export CXXFLAGS=\"-I${GLIB_PATH}/include/glib-2.0 -I${GLIB_PATH}/lib/glib-2.0/include -I${VIPS_PATH}/include\"" >> ~/.zshrc
    fi
    
    # Add LDFLAGS for vips and glib
    if ! grep -q "LDFLAGS=\"-L${VIPS_PATH}/lib -L${GLIB_PATH}/lib\"" ~/.zshrc; then
        echo "export LDFLAGS=\"-L${VIPS_PATH}/lib -L${GLIB_PATH}/lib\"" >> ~/.zshrc
    fi
}

# Main execution
install_vips
install_glib
configure_shell

print_status "Imaging tools setup complete!"
print_status "Please restart your terminal or run 'source ~/.zshrc' in a zsh shell to apply the new environment variables." 