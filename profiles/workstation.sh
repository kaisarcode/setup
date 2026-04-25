#!/bin/bash
# workstation - Workstation Provisioning Profile for Debian 13
# Summary: Full desktop environment plus Sunshine streaming for NVIDIA hosts.
# Author:  KaisarCode
# Website: https://kaisarcode.com
# License: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail

# Enable autologin in LightDM for the primary user.
enable_autologin() {
    local primary_user
    primary_user=$(id -un 1000)
    
    if [ -f /etc/lightdm/lightdm.conf ]; then
        log_info "Enabling autologin for $primary_user..."
        sudo sed -i "s/^#autologin-user=.*/autologin-user=$primary_user/" /etc/lightdm/lightdm.conf
        sudo sed -i "s/^#autologin-user-timeout=.*/autologin-user-timeout=0/" /etc/lightdm/lightdm.conf
    fi
}

# Run the workstation provisioning profile.
main() {
    local PROJECT_ROOT
    PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "$PROJECT_ROOT/lib/utils.sh"

    require_root

    log_info "Initializing Debian 13 WORKSTATION profile (RTX Host)..."
    
    # 1. Base Layer (Core + Drivers + Tailscale + Locales)
    source "$PROJECT_ROOT/profiles/base.sh"

    # 2. Desktop Layer (MATE + Podman)
    source "$PROJECT_ROOT/profiles/desktop.sh"

    # 3. Workstation Specific (Sunshine + Autologin)
    source "$PROJECT_ROOT/modules/sunshine.sh"
    enable_autologin

    log_success "WORKSTATION profile installation complete."
}

main "$@"
