#!/bin/bash
# server - Debian 13 Server Profile
# Summary: Incremental profile: Base + Incus + Podman.
# Author:  KaisarCode
# Website: https://kaisarcode.com
# License: https://www.gnu.org/licenses/gpl-3.0.html

set -euo pipefail

# Run the server provisioning profile.
main() {
    local PROJECT_ROOT
    PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "$PROJECT_ROOT/lib/utils.sh"

    require_root

    log_info "Initializing Debian 13 SERVER profile..."
    
    # 1. Ensure Base is provisioned
    source "$PROJECT_ROOT/profiles/base.sh"

    # 2. Provision Server layer
    source "$PROJECT_ROOT/modules/incus.sh"
    source "$PROJECT_ROOT/modules/podman.sh"

    log_success "SERVER profile installation complete."
}

main "$@"
