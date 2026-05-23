{ config, pkgs, caelestia, ... }: 

{
  home.username = "ciel";
  home.homeDirectory = "/home/ciel";

  # Sinkron dengan stateVersion di configuration.nix lu
  home.stateVersion = "25.11"; 

  # Tempat naruh aplikasi khusus user lu nanti
  home.packages = with pkgs; [
    # fastfetch
    # btop
    # caelestia.packages.${pkgs.system}.with-shell
  ];

  imports = [
    ./modules/caelestia
  ];

  # Ini ditaruh di luar blok Hyprland, tapi tetep di dalam kurung kurawal utama home.nix
  # xdg.configFile."hypr/hyprland.conf".force = true;

  # --- CONFIGURATION GIT DEKLARATIF ---
  programs.git = {
    enable = true;
    userName = "mifzalpersonal";
    userEmail = "mizakigaming89@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # Aktifkan modul internal Home Manager
  programs.home-manager.enable = true;
}