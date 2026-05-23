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
    caelestia.packages.${pkgs.system}.with-shell
  ];

  wayland.windowManager.hyprland.settings = {
    # ... settingan monitor dan keybindings lu kemarin ...

    # 3. KASIH TAHU HYPRLAND BUAT JALANIN CAELESTIA PAS STARTUP
    "exec-once" = [
      "caelestia"
    ];
  };

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
