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
}
