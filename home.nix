{ config, pkgs, ... }: #caelestia

{
  home.username = "ciel";
  home.homeDirectory = "/home/ciel";

  # Sinkron dengan stateVersion di configuration.nix lu
  home.stateVersion = "25.11"; 

  # Tempat naruh aplikasi khusus user lu nanti
  home.packages = with pkgs; [
  ];

  programs.git = {
    enable = true;
    settings = {
    user.name = "mifzalpersonal";
    user.email = "mizakigaming89@gmail.com";
    init.defaultBranch = "main";
  };
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome-themes-extra;
  };

  # Aktifkan modul internal Home Manager
  programs.home-manager.enable = true;
}