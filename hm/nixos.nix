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
  };
  # home-manager.users.viktor = { pkgs, ... }: {
  #   home.packages = [ pkgs.atool pkgs.httpie ];
  #   programs.fish.enable = true;
  # };
  # home-manager.users.viktor = import /home/viktor/nixpkgs/home.nix;
}
