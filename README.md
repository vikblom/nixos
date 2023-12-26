# NixOS

Flake configuration for native or VM NixOS.

## References

https://github.com/mitchellh/nixos-config
https://www.tweag.io/blog/2023-02-09-nixos-vm-on-macos/
https://krisztianfekete.org/nixos-on-apple-silicon-with-utm/
https://drakerossman.com/blog/how-to-convert-default-nixos-to-nixos-with-flakes

https://discourse.nixos.org/t/why-doesnt-nix-collect-garbage-remove-old-generations-from-efi-menu/17592/3

video drivers
boot luks device
flake inputs
flake target
stateVersion
env var for scaling
nixos-hardware for laptop model

probably want to "nixos-rebuild boot ..." so it takes effect next cycle.
Launching all at once seems to cause problems?

## Misc

```
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
