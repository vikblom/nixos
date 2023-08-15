# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Avoid bloating boot
  boot.loader.grub.configurationLimit = 4;

  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.utf8";
    LC_IDENTIFICATION = "sv_SE.utf8";
    LC_MEASUREMENT = "sv_SE.utf8";
    LC_MONETARY = "sv_SE.utf8";
    LC_NAME = "sv_SE.utf8";
    LC_NUMERIC = "sv_SE.utf8";
    LC_PAPER = "sv_SE.utf8";
    LC_TELEPHONE = "sv_SE.utf8";
    LC_TIME = "sv_SE.utf8";
  };

  # Docker
  virtualisation.docker.enable = true;

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    # dpi = 100;

    videoDrivers = [ "nvidia" ];

    layout = "us,se";
    xkbVariant = "";
    xkbOptions = "ctrl:nocaps,grp:win_space_toggle";

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "scale";
    };
    displayManager = {
      defaultSession = "none+i3";
      autoLogin.enable = true;
      autoLogin.user = "viktor";
      sessionCommands = ''
        xinput --set-prop 'Logitech USB Receiver Mouse' 'Device Accel Profile' -1
        xinput --set-prop 'Logitech USB Receiver Mouse' 'Device Accel Constant Deceleration' 1.7

        ${pkgs.xorg.xset}/bin/xset r rate 200 40
      '';
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        i3status
        i3lock
      ];
    };

    libinput = {
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "-0.9";
    };
  };
  # Breaks if adding "se" layout.
  # console.useXkbConfig = true;
  # Not needed?
  # hardware.opengl.enable = true;

  # Emacs Daemon
  services.emacs.enable = true;
  services.emacs.defaultEditor = true;

  # Enable automatic login for the user.
  services.udisks2.enable = true;

  # RaspPi resolution
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Allow dconf in Home Manager config.
  programs.dconf.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lsof
    xclip
    vim
    wget
    curl
    git
    gcc
    gnumake
    binutils
    pkg-config
    killall

    udiskie
    ntfs3g

    xfce.thunar
    xfce.tumbler
    xfce.xfce4-screenshooter
    xfce.xfce4-clipman-plugin
    unclutter

    pavucontrol
    screenfetch

    firefox
    signal-desktop
    discord

    vscode

    mullvad-vpn
    transmission-gtk
  ];

  environment.variables = {
    GDK_DPI_SCALE = "0.8";
  };

  fonts.fonts = [
    pkgs.inconsolata
    pkgs.fira-code
    pkgs.roboto-mono
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.mullvad-vpn.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
