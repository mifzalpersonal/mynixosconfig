# /etc/nixos/helix.nix
{ pkgs, ... }:

{
  

  # LSPs dan tool pendukung
  environment.systemPackages = with pkgs; [
    helix
    nil                            # Nix LSP
    nixfmt                         # Nix Formatter
    vscode-langservers-extracted   # HTML/CSS/JSON/ESLint
    typescript-language-server
    tailwindcss-language-server
    bash-language-server
    yaml-language-server
    intelephense                  # PHP LSP paling stabil buat Laravel
    blade-formatter               # Formatter file .blade.php
  ];
}