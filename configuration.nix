# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
      max-jobs = auto
    '';
  };

  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 4;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };
  # Hardware config must point out /boot.
  # boot.kernel.sysctl = {
  #   "kernel.yama.ptrace_scope" = 0;
  # };

  networking.hostName = "nixos";
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Sound
  # PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

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
  services = {
    xserver = {
      enable = true;
      # dpi = 100;

      xkb.layout = "us,se";
      xkb.variant = "";
      xkb.options = "ctrl:nocaps,grp:win_space_toggle";

      desktopManager = {
        xterm.enable = false;
        wallpaper.mode = "scale";
      };
      displayManager = {
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

    };
    displayManager = {
      defaultSession = "none+i3";
      autoLogin.enable = true;
      autoLogin.user = "viktor";
    };
    libinput = {
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "-0.5";
    };
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
  };
  # Breaks if adding "se" layout.
  # console.useXkbConfig = true;
  # Not needed?
  # hardware.opengl.enable = true;

  # Emacs Daemon
  services.emacs = {
    enable = true;
    package = pkgs.emacs30;
    defaultEditor = true;
  };

  # RaspPi resolution
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  # Allow dconf in Home Manager config.
  programs.dconf.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    file
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
    openssl
    bash

    udiskie
    ntfs3g
    pciutils
    dmidecode
    lshw

    xfce.thunar
    xfce.tumbler
    xfce.xfce4-screenshooter
    xfce.xfce4-clipman-plugin
    unclutter

    pavucontrol
    screenfetch

    firefox

    mullvad-vpn
    transmission-gtk
  ];

  environment.variables = {
    GDK_DPI_SCALE = "0.8";
  };

  fonts.packages = [
    pkgs.inconsolata
    pkgs.fira-code
    pkgs.roboto-mono
    pkgs.meslo-lg
    pkgs.b612
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
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  programs.ssh.startAgent = true;

  programs.noisetorch.enable = true;
  programs.steam.enable = pkgs.stdenv.isx86_64;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 3000 8080 ];
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
