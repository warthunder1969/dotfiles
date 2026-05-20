{ config, pkgs, ... }:

let
  userName = "war";
  userFullName = "Warthunder";
  hostName = "mintbox";
  timezone = "America/Indiana/Indianapolis"; # change as needed
  locale = "en_US.UTF-8";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Basic system identity
  networking.hostName = hostName;
  time.timeZone = timezone;

  i18n = {
    defaultLocale = locale;
    consoleFont = "Lat2-Terminus16";
  };

  # Users
  users.users = {
    "${userName}" = {
      isNormalUser = true;
      description = userFullName;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "wheel" "lp" "storage" "bluetooth" ];
      hashedPassword = "<replace-with-password-hash-or-use-accounts.passwordFile>"; # replace or use `passwd` after install
      createHome = true;
      shell = pkgs.bash;
    };
    # Optionally root passwordless sudo (not recommended) or leave root locked
  };

  # Allow members of wheel to use sudo
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Graphical stack: Cinnamon desktop and Nemo file manager
  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager.default = "cinnamon";
    displayManager.lightdm.enable = true;
    displayManager.lightdm.greeter = pkgs.lightdm-gtk-greeter; # LightDM + GTK greeter like Mint
    windowManager.default = "muffin"; # Cinnamon's window manager (muffin)
#    videoDrivers = [ "nvidia" ]; # change to "intel", "amdgpu", or remove if using auto
    # Alternatively, don't set videoDrivers to let Nix pick
  };

  services = {
    # Cinnamon service comes from package
  };

  # Use Cinnamon package and Nemo
  environment.systemPackages = with pkgs; [
    cinnamon            # Cinnamon desktop environment
    nemo                # Nemo file manager (Mint's default)
    nemo-fileroller     # archive support
    gnome-terminal      # terminal similar to Mint
    xreader             # document reader similar to Mint's
    pluma               # simple text editor (or gedit)
    xed                 # lightweight editor (alternatively pluma)
    firefox             # browser (or firefox-devedition)
    libreoffice         # office suite like Mint
    vlc                 # media player
    mint-backgrounds    # if available in channels; else add wallpaper package or custom file
    gimp
    htop
    networkmanager
    network-manager-applet
    bluez
    blueman
    cups
    cups-pdf
    cups-browsed
    samba
    rsync               # useful for Timeshift-like backups
    timeshift           # if available in your channel, otherwise use borgrestic/backups (may not be packaged)
    flatpak
    ripgrep
    p7zip
    unzip
    wget
    udisks2
    gvfs
    mint-y-icons
    mint-l-icons
    mint-x-icons
    mint-themes
    mint-cursor-themes
    mint-l-theme
    mint-artwork
  ];

  # Enable services commonly used in Mint
  services = {
    # network manager allows tray network applet behavior similar to Mint
    networkmanager.enable = true;
    # Bluetooth
    bluetooth.enable = true;
    # Printing
    cups.enable = true;
    # Samba for file sharing
    samba.enable = true;
    # Avahi for network discovery (used by many desktop apps)
    avahi.enable = true;
    avahi.nssmdns = true;
  } // config.services;

  # Enable Flatpak and allow per-user installation
  programs.flatpak.enable = true;

  # Sound
  sound = {
    enable = true;
    alsa.enable = true;
    pulseaudio.enable = true;
  };

  # Fonts: include common fonts used on Mint
  fonts = {
    enableFonts = true;
    fonts = with pkgs; [
      dejavu_fonts
      noto-fonts
      noto-fonts-emoji
      fontconfig
      ttf-ubuntu-font-family
      liberation_ttf
      # optionally add 'noto-sans-mono' etc.
    ];
  };

  # Theme & appearance: try to match Mint's look (Mint-Y if available)
  nixpkgs.config.packageOverrides = pkgs: {
    myThemes = with pkgs; [
      # If Mint themes packaged in your channel, include them; otherwise include popular GTK themes
      arc-theme
      materia
      adapta-gtk-theme
      papirus-icon-theme
    ];
  };

  # Environment for user: set default session to Cinnamon
  users.users."${userName}".packages = with pkgs; [
    cinnamon
    nemo
    flatpak
  ];

  # Enable auto-login optionally (uncomment to enable)
  # services.displayManager.lightdm.autoLogin = {
  #   enable = true;
  #   user = userName;
  # };

  # Enable and configure snapshots & rollback: use nixos-generation snapshots + Timeshift-like
  boot = {
    kernelParams = [ "quiet" ];
    # Enable ZFS or Btrfs snapshots if using those filesystems. Example for btrfs:
    # If you use btrfs root, enable btrfs automatic snapshots with snapper (optional)
  };

  # Optional: enable automatic systemd-boot for UEFI, or adapt for grub
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # Printing permissions
  hardware.pulseaudio = {
    enable = true;
  };

  # Extra desktop conveniences: user-friendly power, updates, and session tools
  services.updates = {
    # This is not a Mint-style automatic update GUI; use GNOME Software for GUI updates with Flatpak support
  };

  # Enable gnome-software with flatpak plugin for app store feel (like Mint Software Manager)
  environment.systemPackages = lib.mkForce (with pkgs; [
    gnome-software
    gnome-software-plugin-flatpak
    gnome-software-plugin-snap   # optional if using snap
  ]) ++ config.environment.systemPackages;

  # Set up polkit rules to allow passwordless mounts and printer management (optional — keep secure)
  security.polkit.enable = true;

  # Enable auto-mounting and media handling via udisks2 + gvfs
  services.gnome3.gnome-settings-daemon.enable = true;

  # Privacy-ish: avoid telemetry packages (default NixOS is minimal)
  system = {
    packages = []; # reserved
  };

  # System limits, journald rotation, and other OS niceties
  systemd = {
    services = {};
  };

  # Enable common kernel modules (if using virtualbox or nvidia, manage them)
  hardware = {
    enableRedistributableFirmware = true;
    acpi = {
      enable = true;
    };
  };

  # Enable swap file if desired (Mint by default uses swap partition or swapfile)
  swapDevices = [
    { device = "/swapfile"; size = 2048; } # 2GiB swapfile; create file beforehand or use systemd-swap
  ];

  # System activation: allow local user to manage NetworkManager connections (for GUI convenience)
  networking.networkmanager.enable = true;

  # Misc: make sure Nemo is used to handle desktop icons (Cinnamon does this)
  # Provide MIME and defaults
  environment.variables = {
    XDG_CURRENT_DESKTOP = "X-Cinnamon";
    GTK_THEME = "Adwaita"; # change to Mint-Y if available
  };

  # Services for power management and laptop niceties
  services.upower.enable = true;
  services.consolekit.enable = false;

  # Enable printing protocols
  hardware.printer.enable = true;

  # Allow members of plugdev to mount removable media (if desired)
  environment.systemPackages = config.environment.systemPackages;

  # System automatic updates are not enabled by default on NixOS. For a Mint-like update manager you can:
  # - Use gnome-software for GUI updates (Flatpak/OS packages)
  # - Use a script to run `nix-channel --update && nixos-rebuild switch`
  # (Automated upgrade is intentionally omitted here)

  # Final NixOS options
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Services and packages not available in your channel: if timeshift or mint backgrounds aren't present,
  # add them via overlays or fetch them from third-party repos; this configuration assumes common packages exist.
}
