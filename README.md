# KCS Debian 13 Provisioning Tool

Modular and idempotent system for provisioning Debian 13 (Trixie) environments.

## Architecture

1.  **Library (`lib/`)**: Shared logic and idempotency helpers (`apt_install`, `log_*`).
2.  **Installers (`*.sh`)**: Root-level provisioning units that can be run independently.

## Quick Start (Bare Metal)

To prepare a new Debian 13 machine and start provisioning:

```bash
# 1. As root, install sudo and add your user to the group
su -
apt update && apt install -y sudo git
usermod -aG sudo <your_user>
reboot

# 2. Back as normal user, clone and run the setup
git clone https://github.com/kaisarcode/setup
cd setup
./core.sh
```

## Installers

Each installer is an atomic provisioning unit:

- **`core.sh`**: Configures Debian repositories, base packages, and core services.
- **`drivers.sh`**: Installs CPU microcode, NVIDIA support, and PipeWire audio.
- **`desktop.sh`**: Installs MATE, LightDM, desktop tools, and NetworkManager.
- **`locales.sh`**: Configures English system locales and English XDG directories.
- **`autologin.sh`**: Enables LightDM autologin for the primary user.
- **`podman.sh`**: Installs Podman, Distrobox, and rootless container support.
- **`code.sh`**: Creates an isolated Distrobox coding environment with VS Code and Antigravity.
- **`incus.sh`**: Installs and initializes Incus.
- **`flatpak.sh`**: Installs Flatpak and adds Flathub.
- **`tailscale.sh`**: Installs Tailscale and enables its service.
- **`sunshine.sh`**: Installs and configures Sunshine for game streaming.
- **`theme.sh`**: Installs and applies the Yaru dark theme for MATE.
- **`wine.sh`**: Installs Wine, i386 support, and Winetricks.

Run only the installers needed for the target machine:

```bash
./core.sh
./drivers.sh
./desktop.sh
./locales.sh
```

---

**Author:** KaisarCode

**Email:** <kaisar@kaisarcode.com>

**Website:** [https://kaisarcode.com](https://kaisarcode.com)

**License:** [GNU GPL v3.0](https://www.gnu.org/licenses/gpl-3.0.html)

© 2026 KaisarCode
