# Use: nix-shell -p git emacs

git clone https://github.com/vikblom/nixos.git
cd nixos

cp /etc/nixos/hardware-configuration.nix ./hardware/<SYSTEM>.nix

# Add the new system as a flake target.
emacs -nw flake.nix

sudo nixos-rebuild --flake .#<SYSTEM> switch
