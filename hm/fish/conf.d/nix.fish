# Does not work on multiuser?
# if test -e /home/viktor/.nix-profile/etc/profile.d/nix.fish; . /home/viktor/.nix-profile/etc/profile.d/nix.fish; end # added by Nix installer

if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish; . /nix/var/nix/profiles/default/etc/profile.d/nix.fish; end
