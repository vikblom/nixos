{ pkgs, lib, ... }:

# Nix config.
# Most parts inspired/stolen from github.com/mitchellh/nixos-config.
#
#
# https://nix-community.github.io/home-manager/index.html
# https://nixos.wiki/wiki/Cheatsheet
# https://www.bekk.christmas/post/2021/16/dotfiles-with-nix-and-home-manager
# https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix
# https://github.com/mitchellh/nixos-config/blob/c812e681dd72dd0d818fbdce275e75171ea858b2/users/mitchellh/home-manager.nix
#
# https://github.com/NixOS/nixpkgs/issues/196651
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Colorful MANPAGER
  manpager = (pkgs.writeShellScriptBin "manpager" (if isDarwin then ''
    sh -c 'col -bx | bat -l man -p'
  '' else ''
    sh -c "bat -l man -p"
  ''));
in
{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";


  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "viktor";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/viktor" else "/home/viktor";

  xdg.enable = true;

  # Workaround for
  # https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false;

  # -- Packages

  # Pkgs to install
  # Find through: nix-env -qaP <pkg>
  # Or: https://search.nixos.org/packages
  home.packages = [
    pkgs.fish
    pkgs.tmux
    pkgs.git
    pkgs.direnv
    pkgs.emacs
    pkgs.neovim
    pkgs.sbcl

    pkgs.go
    pkgs.gopls
    pkgs.delve
    # https://nixos.wiki/wiki/Packaging/Binaries
    pkgs.patchelf

    pkgs.python3

    pkgs.rustc
    pkgs.cargo
    # pkgs.rustup # So we can rustup --docs
    pkgs.rust-analyzer
    # pkgs.gdb
    # pkgs.linuxPackages_latest.perf

    pkgs.zig
    pkgs.zls

    pkgs.nixfmt-classic
    pkgs.nil
    pkgs.nix-search-cli

    pkgs.cmake

    pkgs.clojure-lsp

    pkgs.bat
    pkgs.fd
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
    pkgs.watch
    pkgs.fzf

    pkgs.kubectl

    # Daemon installed separately
    pkgs.docker
    pkgs.docker-compose
    pkgs.kind
    pkgs.helm
    pkgs.istioctl
    pkgs.envoy

    pkgs.postgresql
    pkgs.sqlite
    pkgs.dbmate

    # https://github.com/nix-community/home-manager/issues/3113
    pkgs.dconf

    pkgs.hugo
    pkgs.dig

    pkgs.livekit
    pkgs.livekit-cli
    pkgs.obs-studio
    pkgs.nodejs
    pkgs.pnpm

  ] ++ (lib.optionals isDarwin [
    pkgs.iterm2
    pkgs.lima
    pkgs.colima
    # pkgs.podman

  ]) ++ (lib.optionals isLinux [
    pkgs.kitty
    # pkgs.chromium
    pkgs.firefox
    pkgs.ungoogled-chromium
    pkgs.rofi
    pkgs.rr
    pkgs.ffmpeg
    pkgs.openshot-qt
    pkgs.audacity
    pkgs.yt-dlp

    pkgs.evince
    pkgs.spotify
    pkgs.calibre
  ]);

  # --  Env

  home.sessionVariables = {
    EDITOR = "emacsclient -nw -a emacs";
    LESS = "-r";
    PAGER = "less -FirSwX";
    MANPAGER = "${manpager}/bin/manpager";
  };

  # -- Dotfiles

  home.file.".background-image".source = ./background.jpeg;
  home.file.".tmux.conf".source = ./tmux/tmux.conf;
  xdg.configFile."i3/config".text = builtins.readFile ./i3;
  xdg.configFile."i3status/config".text = builtins.readFile ./i3status;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;
  # Collides with tools at work.
  # home.file.".gitconfig".source = ./git/gitconfig;

  # -- Programs

  # home.file.".config/fish/config.fish".source = ./fish/config.fish;
  # home.file.".config/fish/conf.d/nix.fish".source = ./fish/conf.d/nix.fish;
  # is replaced by?
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" [
      (builtins.readFile ./fish/config.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
    ]);

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gdiff = "git diff";
      gp = "git push";
      gri = "git rebase --interactive";
      gs = "git status";
      gt = "git tag";
    };
  };

  # programs.ssh = {
  #   enable = true;
  # }

  # -- Graphics

  gtk = {
    enable = isLinux;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  home.sessionVariables.GTK_THEME = "palenight";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
