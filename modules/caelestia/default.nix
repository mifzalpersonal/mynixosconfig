{ config, pkgs, inputs, ... }:

{
  home.packages = [
    inputs.caelestia.packages.${pkgs.system}.default
  ];

  # Jalankan otomatis pas login Hyprland
  wayland.windowManager.hyprland.settings."exec-once" = [
    "caelestia shell"
  ];
}