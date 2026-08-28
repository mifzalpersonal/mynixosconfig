# /etc/nixos/helix.nix
{ pkgs, ... }:

{
  # LSPs dan tool pendukung
  environment.systemPackages = with pkgs; [
    zsh-fzf-tab
    zsh-vi-mode
    zsh-you-should-use
    zsh-forgit
  ];
}