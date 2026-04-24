#!/bin/bash
# sunshine - Sunshine streaming server for Debian 13
# Summary: Installs Sunshine and configures uinput permissions and autostart.
# Author:  KaisarCode
# Website: https://kaisarcode.com
# License: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail

# Install Sunshine dependencies.
install_dependencies() {
    log_info "Installing Sunshine dependencies..."
    apt_install "libevdev2"
    apt_install "libpulse0"
    apt_install "libxcb-randr0"
    apt_install "libxcb-xtest0"
}

# Download and install the latest Sunshine package.
install_sunshine_pkg() {
    if command_exists sunshine; then
        log_skip "Sunshine is already installed."
        return 0
    fi

    log_info "Downloading latest Sunshine release for Debian Trixie..."
    local DEB_URL="https://github.com/LizardByte/Sunshine/releases/latest/download/sunshine-debian-trixie-amd64.deb"
    
    curl -L --output /tmp/sunshine.deb "$DEB_URL"
    sudo dpkg -i /tmp/sunshine.deb || sudo apt-get install -y -f
    rm /tmp/sunshine.deb
}

# Configure permissions and user service.
configure_sunshine() {
    log_info "Configuring Sunshine permissions..."
    
    # Allow sunshine to create input devices
    sudo setcap cap_sys_admin+ep $(which sunshine)

    # Enable uinput rules if missing
    if [ ! -f /etc/udev/rules.d/60-sunshine.rules ]; then
        echo 'KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/60-sunshine.rules > /dev/null
    fi

    log_info "Enabling Sunshine user service..."
    systemctl --user enable --now sunshine.service 2>/dev/null || true
}

# Run the sunshine provisioning.
main() {
    local PROJECT_ROOT
    PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "$PROJECT_ROOT/lib/utils.sh"

    log_info "Running Sunshine Provisioning..."
    install_dependencies
    install_sunshine_pkg
    configure_sunshine
    log_success "Sunshine Provisioning complete."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
