# /etc/nixos/helix.nix
{ pkgs, ... }:

{
  

  # LSPs dan tool pendukung
  environment.systemPackages = with pkgs; [
    helix
    nil                            # Nix LSP
    vscode-langservers-extracted   # HTML/CSS/JSON/ESLint
    typescript-language-server
    tailwindcss-language-server
    bash-language-server
    yaml-language-server
    intelephense                  # PHP LSP paling stabil buat Laravel

    cargo
    rustc
    #rustfmt
    #clippy
    #rust-analyzer

    # Utilities & C Libraries untuk Kompilasi
    pkg-config
    openssl
  ];
}