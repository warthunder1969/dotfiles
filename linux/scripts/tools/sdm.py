#!/usr/bin/env python3
"""
drivermgr.py - Simple Driver Manager TUI: a curses-based TUI for managing
Linux driver installation.

Targets Debian/Ubuntu-based systems (apt). It will still run on other distros
for the "scan hardware" and "loaded modules" screens, but package install/
remove and "recommended drivers" rely on apt / ubuntu-drivers-common.

Run with:  python3 drivermgr.py
(No install needed - only uses the Python standard library.)
"""

import curses
import curses.textpad
import shutil
import subprocess
import textwrap
from datetime import datetime

APT_AVAILABLE = shutil.which("apt") is not None or shutil.which("apt-get") is not None
UBUNTU_DRIVERS_AVAILABLE = shutil.which("ubuntu-drivers") is not None


# --------------------------------------------------------------------------
# Shell helpers
# --------------------------------------------------------------------------

def run(cmd, timeout=30):
    """Run a command, return (returncode, stdout, stderr) without raising."""
    try:
        result = subprocess.run(
            cmd, shell=isinstance(cmd, str), capture_output=True,
            text=True, timeout=timeout
        )
        return result.returncode, result.stdout, result.stderr
    except FileNotFoundError as e:
        return 127, "", str(e)
    except subprocess.TimeoutExpired:
        return 124, "", "Command timed out"


def run_interactive(cmd):
    """
    Leave curses mode, run a command with the terminal fully available
    (so sudo password prompts etc. work normally), then resume curses.
    Returns the exit code.
    """
    curses.endwin()
    print("\n$ " + " ".join(cmd) + "\n")
    rc = subprocess.call(cmd)
    input("\n[Command finished, exit code {}] Press Enter to return...".format(rc))
    return rc


# --------------------------------------------------------------------------
# Data gathering
# --------------------------------------------------------------------------

def scan_pci():
    if not shutil.which("lspci"):
        return ["lspci not found - install 'pciutils' to enable PCI scanning."]
    rc, out, err = run(["lspci", "-nnk"])
    if rc != 0:
        return ["Error running lspci: " + err]
    return out.splitlines()


def scan_usb():
    if not shutil.which("lsusb"):
        return ["lsusb not found - install 'usbutils' to enable USB scanning."]
    rc, out, err = run(["lsusb"])
    if rc != 0:
        return ["Error running lsusb: " + err]
    return out.splitlines()


def loaded_modules():
    rc, out, err = run(["lsmod"])
    if rc != 0:
        return ["Error running lsmod: " + err]
    return out.splitlines()


def recommended_drivers():
    if UBUNTU_DRIVERS_AVAILABLE:
        rc, out, err = run(["ubuntu-drivers", "devices"], timeout=60)
        if rc == 0 and out.strip():
            return out.splitlines()
        return ["ubuntu-drivers returned no output.", err]
    return [
        "'ubuntu-drivers' tool not found on this system.",
        "It's normally provided by the 'ubuntu-drivers-common' package.",
        "Falling back: use 'Search / install a package' to find driver",
        "packages manually (e.g. search for 'nvidia-driver' or 'firmware-').",
    ]


def apt_search(term):
    if not shutil.which("apt-cache"):
        return ["apt-cache not found - this feature needs a Debian/Ubuntu system."]
    rc, out, err = run(["apt-cache", "search", term], timeout=30)
    if rc != 0:
        return ["Error: " + err]
    lines = out.splitlines()
    return lines if lines else ["No packages matched '{}'.".format(term)]


def package_installed(pkg):
    rc, out, err = run(["dpkg", "-s", pkg])
    return rc == 0


# --------------------------------------------------------------------------
# TUI primitives
# --------------------------------------------------------------------------

class TUI:
    def __init__(self, stdscr):
        self.stdscr = stdscr
        curses.curs_set(0)
        curses.start_color()
        curses.use_default_colors()
        curses.init_pair(1, curses.COLOR_CYAN, -1)     # headers
        curses.init_pair(2, curses.COLOR_GREEN, -1)    # success / ok
        curses.init_pair(3, curses.COLOR_YELLOW, -1)   # warnings
        curses.init_pair(4, curses.COLOR_BLACK, curses.COLOR_CYAN)  # selection
        self.log = []
        self.log_event("drivermgr started. apt={} ubuntu-drivers={}".format(
            APT_AVAILABLE, UBUNTU_DRIVERS_AVAILABLE))

    def log_event(self, msg):
        ts = datetime.now().strftime("%H:%M:%S")
        self.log.append("[{}] {}".format(ts, msg))
        self.log = self.log[-200:]

    # ---- generic widgets ----

    def message(self, lines, title="Message"):
        self.text_viewer(lines, title=title)

    def text_viewer(self, lines, title="View"):
        """Scrollable read-only viewer for a list of lines."""
        h, w = self.stdscr.getmaxyx()
        top = 0
        while True:
            self.stdscr.erase()
            self.draw_title(title)
            body_h = h - 4
            visible = lines[top: top + body_h]
            for i, line in enumerate(visible):
                self.safe_addstr(2 + i, 4, line[: w - 6])
            self.draw_footer("UP/DOWN/PGUP/PGDN scroll   q/ESC back")
            self.stdscr.refresh()
            key = self.stdscr.getch()
            if key in (ord('q'), 27):
                return
            elif key == curses.KEY_UP and top > 0:
                top -= 1
            elif key == curses.KEY_DOWN and top < max(0, len(lines) - body_h):
                top += 1
            elif key == curses.KEY_PPAGE:
                top = max(0, top - body_h)
            elif key == curses.KEY_NPAGE:
                top = min(max(0, len(lines) - body_h), top + body_h)

    def menu(self, items, title="Menu", footer=None):
        """items: list of (label, ...). Returns selected index or None."""
        idx = 0
        h, w = self.stdscr.getmaxyx()
        while True:
            self.stdscr.erase()
            self.draw_title(title)
            for i, label in enumerate(items):
                y = 2 + i
                if y >= h - 2:
                    break
                if i == idx:
                    # Reverse-video + bold is visible even on terminals
                    # without usable color support, plus an explicit
                    # cursor marker so selection is never ambiguous.
                    attr = curses.A_REVERSE | curses.A_BOLD
                    if curses.has_colors():
                        attr |= curses.color_pair(4)
                    marker = "> "
                    self.stdscr.attron(attr)
                    self.safe_addstr(y, 2, (marker + label).ljust(w - 4))
                    self.stdscr.attroff(attr)
                else:
                    self.safe_addstr(y, 2, "  " + label)
            self.draw_footer(footer or "UP/DOWN move   ENTER select   q back")
            self.stdscr.refresh()
            key = self.stdscr.getch()
            if key in (curses.KEY_UP, ord('k')) and idx > 0:
                idx -= 1
            elif key in (curses.KEY_DOWN, ord('j')) and idx < len(items) - 1:
                idx += 1
            elif key in (10, 13, curses.KEY_ENTER):
                return idx
            elif key in (ord('q'), 27):
                return None

    def prompt(self, label):
        h, w = self.stdscr.getmaxyx()
        self.stdscr.erase()
        self.draw_title(label)
        curses.curs_set(1)
        self.safe_addstr(3, 2, "> ")
        self.stdscr.refresh()
        win = curses.newwin(1, w - 6, 3, 4)
        box = curses.textpad.Textbox(win)
        text = box.edit().strip()
        curses.curs_set(0)
        return text

    def confirm(self, question):
        idx = self.menu(["Yes", "No"], title=question)
        return idx == 0

    def draw_title(self, title):
        h, w = self.stdscr.getmaxyx()
        self.stdscr.attron(curses.color_pair(1) | curses.A_BOLD)
        self.safe_addstr(0, 4, title)
        self.stdscr.attroff(curses.color_pair(1) | curses.A_BOLD)
        self.safe_addstr(1, 2, "-" * min(w - 4, 70))

    def draw_footer(self, text):
        h, w = self.stdscr.getmaxyx()
        self.safe_addstr(h - 1, 2, text[: w - 4], curses.A_DIM)

    def safe_addstr(self, y, x, text, attr=0):
        h, w = self.stdscr.getmaxyx()
        if 0 <= y < h:
            try:
                self.stdscr.addstr(y, x, text[: max(0, w - x - 1)], attr)
            except curses.error:
                pass


# --------------------------------------------------------------------------
# Application screens
# --------------------------------------------------------------------------

def screen_hardware(ui):
    while True:
        choice = ui.menu(
            ["PCI devices (lspci -nnk)", "USB devices (lsusb)", "Back"],
            title="Scan Hardware",
        )
        if choice is None or choice == 2:
            return
        if choice == 0:
            ui.log_event("Scanned PCI devices")
            ui.text_viewer(scan_pci(), title="PCI Devices")
        elif choice == 1:
            ui.log_event("Scanned USB devices")
            ui.text_viewer(scan_usb(), title="USB Devices")


def screen_recommended(ui):
    ui.log_event("Fetched recommended driver list")
    lines = recommended_drivers()
    ui.text_viewer(lines, title="Recommended Drivers")

    if not UBUNTU_DRIVERS_AVAILABLE:
        return

    # Offer to auto-install
    if ui.confirm("Run 'sudo ubuntu-drivers autoinstall' now?"):
        ui.log_event("Running ubuntu-drivers autoinstall")
        rc = run_interactive(["sudo", "ubuntu-drivers", "autoinstall"])
        ui.log_event("ubuntu-drivers autoinstall exited with code {}".format(rc))


def screen_search(ui):
    if not APT_AVAILABLE:
        ui.message(["apt / apt-get not found on this system.",
                    "Package search requires a Debian/Ubuntu-based distro."],
                   title="Unavailable")
        return
    term = ui.prompt("Search term (e.g. nvidia, firmware-linux, broadcom)")
    if not term:
        return
    ui.log_event("Searched apt for '{}'".format(term))
    results = apt_search(term)
    # Turn into a selectable menu of package names (first column)
    pkg_names = []
    labels = []
    for line in results:
        if " - " in line:
            name = line.split(" - ", 1)[0].strip()
            pkg_names.append(name)
            installed = package_installed(name)
            mark = "[installed] " if installed else ""
            labels.append(mark + line)
        else:
            pkg_names.append(None)
            labels.append(line)
    labels.append("Back")
    idx = ui.menu(labels, title="Search results for '{}'".format(term),
                  footer="ENTER to manage package   q back")
    if idx is None or idx == len(labels) - 1:
        return
    pkg = pkg_names[idx]
    if not pkg:
        return
    manage_package(ui, pkg)


def screen_install_menu(ui):
    if not APT_AVAILABLE:
        ui.message(["apt / apt-get not found on this system.",
                    "Package install requires a Debian/Ubuntu-based distro."],
                   title="Unavailable")
        return
    items = [
        "nvidia-driver (current NVIDIA, meta-package)",
        "nvidia-driver-legacy (340 / 390 / 470 series)",
        "broadcom b43 / b43legacy (firmware installers)",
        "broadcom-wl (broadcom-sta-dkms)",
        "Back",
    ]
    idx = ui.menu(items, title="Install a Driver Package")
    if idx is None or idx == 4:
        return
    if idx == 0:
        manage_package(ui, "nvidia-driver")
    elif idx == 1:
        screen_nvidia_legacy(ui)
    elif idx == 2:
        screen_broadcom_b43(ui)
    elif idx == 3:
        manage_package(ui, "broadcom-sta-dkms")


def screen_nvidia_legacy(ui):
    options = [
        "nvidia-340  (legacy 340 series - very old GPUs)",
        "nvidia-390  (legacy 390 series)",
        "nvidia-470  (legacy 470 series - last to support many Kepler cards)",
        "Back",
    ]
    idx = ui.menu(options, title="NVIDIA Legacy Driver")
    if idx is None or idx == 3:
        return
    pkg = ["nvidia-340", "nvidia-390", "nvidia-470"][idx]
    manage_package(ui, pkg)


def screen_broadcom_b43(ui):
    options = [
        "firmware-b43-installer         (b43 - newer Broadcom chips)",
        "firmware-b43legacy-installer   (b43legacy - older Broadcom chips)",
        "Back",
    ]
    idx = ui.menu(options, title="Broadcom b43 / b43legacy")
    if idx is None or idx == 2:
        return
    pkg = ["firmware-b43-installer", "firmware-b43legacy-installer"][idx]
    manage_package(ui, pkg)


def manage_package(ui, pkg):
    installed = package_installed(pkg)
    action_label = "Remove {}".format(pkg) if installed else "Install {}".format(pkg)
    options = [action_label, "Show package info (apt-cache show)", "Back"]
    idx = ui.menu(options, title=pkg)
    if idx is None or idx == 2:
        return
    if idx == 0:
        cmd = ["sudo", "apt-get", "remove", pkg] if installed else ["sudo", "apt-get", "install", pkg]
        if ui.confirm("Run: {}?".format(" ".join(cmd))):
            ui.log_event("Running: {}".format(" ".join(cmd)))
            rc = run_interactive(cmd)
            ui.log_event("{} exited with code {}".format(" ".join(cmd), rc))
    elif idx == 1:
        rc, out, err = run(["apt-cache", "show", pkg])
        ui.text_viewer(out.splitlines() if rc == 0 else [err], title="apt-cache show " + pkg)


def screen_modules(ui):
    ui.log_event("Listed loaded kernel modules")
    ui.text_viewer(loaded_modules(), title="Loaded Kernel Modules (lsmod)")


def screen_log(ui):
    ui.text_viewer(list(reversed(ui.log)), title="Activity Log (most recent first)")


def main(stdscr):
    ui = TUI(stdscr)
    items = [
        "Scan hardware (PCI / USB)",
        "Show recommended drivers",
        "Install a driver package",
        "Search for a driver package",
        "View loaded kernel modules",
        "View activity log",
        "Quit",
    ]
    while True:
        choice = ui.menu(items, title="Simple Driver Manager TUI")
        if choice is None or choice == 6:
            break
        elif choice == 0:
            screen_hardware(ui)
        elif choice == 1:
            screen_recommended(ui)
        elif choice == 2:
            screen_install_menu(ui)
        elif choice == 3:
            screen_search(ui)
        elif choice == 4:
            screen_modules(ui)
        elif choice == 5:
            screen_log(ui)


if __name__ == "__main__":
    curses.wrapper(main)
