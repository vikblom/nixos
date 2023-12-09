{ pkgs, ... }:

{
  # For shell.
  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.viktor = {
    isNormalUser = true;
    description = "Viktor Blomqvist";
    extraGroups = [ "networkmanager" "wheel" "audio" "plugdev" "docker" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINYsMD0rc+ipckgmCU/vnbOiRqUPzLYMw8YEhbco2kN4 viktor@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4JjpJGv47qlVRIRAj76WCbLXY9ykRzuw3QjOPGlxX5 viktor@zimpler-macbook"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlK6pjeOlyifYOsDn4RmOKMxmNWwd/KnawQsnzewtbA viktor@orion"
    ];
  };
  # home-manager.users.viktor = { pkgs, ... }: {
  #   home.packages = [ pkgs.atool pkgs.httpie ];
  #   programs.fish.enable = true;
  # };
  # home-manager.users.viktor = import /home/viktor/nixpkgs/home.nix;
}
