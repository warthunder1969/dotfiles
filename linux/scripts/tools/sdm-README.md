# Simple Driver Manager TUI

A lightweight, dependency-free terminal UI for viewing hardware, checking
loaded kernel modules, and installing/removing Linux driver packages.

Built with Python's built-in `curses` library — no packages to install
before running it.

## Credit

This application was written by Claude (Anthropic's AI assistant), based on an interactive back-and-forth design and testing process. Review the code before running it with sudo, as with any script from an AI or unfamiliar source.

## Requirements

- Linux
- Python 3
- A Debian/Ubuntu-based distro (uses `apt`/`apt-get`/`apt-cache`/`dpkg`) for
  the install, search, and recommended-drivers features
- Optional, for full functionality:
  - `pciutils` (`lspci`) — for the PCI hardware scan
  - `usbutils` (`lsusb`) — for the USB hardware scan
  - `ubuntu-drivers-common` (`ubuntu-drivers`) — for the recommended-drivers
    screen and one-click `autoinstall`

If a tool is missing, the app tells you which package provides it instead of
crashing.

The hardware scan and kernel-module screens will still work on non-Debian
distros; the install/search/recommended screens require `apt` and won't be
usable on distros that don't have it (e.g. Fedora, Arch).

## Running it

```bash
python3 drivermgr.py
```

No `pip install` needed. Some actions (installing/removing packages,
`ubuntu-drivers autoinstall`) call `sudo`, so you'll be prompted for your
password when you run those.

## Navigation

| Key(s)              | Action                          |
|----------------------|----------------------------------|
| `↑` / `k`            | Move selection up               |
| `↓` / `j`            | Move selection down             |
| `Enter`              | Select highlighted item          |
| `q` or `Esc`         | Go back / cancel                |
| `Page Up` / `Page Down` | Scroll a long text view faster |

The currently selected menu item is shown in reverse video with a `>`
marker in front of it, so it's visible even on terminals without color
support.

## Main Menu

### Scan hardware (PCI / USB)
Runs `lspci -nnk` and/or `lsusb` and shows the output in a scrollable
viewer. Useful for identifying what hardware is present and which kernel
driver (if any) is currently bound to a PCI device.

### Show recommended drivers
Runs `ubuntu-drivers devices` to list drivers Ubuntu recommends for your
hardware (most relevant for NVIDIA GPUs and some Wi-Fi/Broadcom chips).
After showing the list, it offers to run:

```
sudo ubuntu-drivers autoinstall
```

which installs Ubuntu's recommended driver set automatically. This option
only appears if `ubuntu-drivers` is installed on your system.

### Install a driver package
A curated menu of common driver packages so you don't have to know exact
package names ahead of time:

- **nvidia-driver** — the current NVIDIA driver meta-package (installs
  whatever version your distro currently recommends)
- **nvidia-driver-legacy** — opens a submenu to pick a legacy NVIDIA series
  for older GPUs:
  - `nvidia-340`
  - `nvidia-390`
  - `nvidia-470`
- **broadcom b43 / b43legacy** — opens a submenu for older Broadcom Wi-Fi
  chips that use the open-source `b43` driver plus proprietary firmware:
  - `firmware-b43-installer`
  - `firmware-b43legacy-installer`
- **broadcom-wl** — installs `broadcom-sta-dkms`, the proprietary
  "wl" driver used by newer Broadcom Wi-Fi chips that `b43` doesn't support

Selecting any of these takes you to the **package action screen** (see
below).

> **Note:** exact package names/versions vary by distro release (e.g.
> Ubuntu may ship `nvidia-driver-535`, `nvidia-driver-550`, etc. instead of
> a plain `nvidia-driver` in some cases). If a package reports as
> unavailable, use **Search for a driver package** to find what's actually
> in your repositories.

### Search for a driver package
Prompts for a free-text search term and runs `apt-cache search <term>`
against it (e.g. `nvidia`, `broadcom`, `firmware-linux`). Results already
installed on your system are marked `[installed]`. Selecting a result opens
the same package action screen used by the Install menu.

### Package action screen
Shown whenever you pick a specific package (from either Install or Search).
Options are:

- **Install `<package>`** / **Remove `<package>`** (label switches
  automatically based on whether it's already installed) — runs
  `sudo apt-get install <package>` or `sudo apt-get remove <package>`,
  after a yes/no confirmation. The TUI temporarily exits full-screen mode
  for this so you see normal terminal output and can enter your `sudo`
  password, then returns to the menu when the command finishes.
- **Show package info** — runs `apt-cache show <package>` and displays the
  description, dependencies, and version info in a scrollable viewer.

### View loaded kernel modules
Runs `lsmod` and shows the result — useful for confirming whether a driver
module actually loaded after installation (you may need to reboot or
manually `modprobe` it first).

### View activity log
Shows a running, timestamped log of actions taken during the current
session (scans performed, searches run, install/remove commands executed
and their exit codes), most recent first. This log is in-memory only and
resets each time you restart the app.

### Quit
Exits the application.

## Notes & Limitations

- This tool shells out directly to `sudo apt-get install/remove` — treat
  choices here the same as you would running those commands yourself in a
  terminal. There's no dry-run or automatic rollback.
- It's built and tested against Debian/Ubuntu-based systems. Package
  install/search and the recommended-drivers screen won't work on
  non-apt distros (Fedora, Arch, openSUSE, etc.) without modification.
- Installing a driver (especially NVIDIA or Broadcom Wi-Fi drivers) often
  requires a reboot before it takes effect.
