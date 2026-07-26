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

  programs.kitty = {
    enable = true;
    # These settings are written to ~/.config/kitty/kitty.conf by Home Manager
    # Noctalia will NOT overwrite these because we are not letting it manage the main file
    settings = {
      background_opacity = "0.75";
      hide_window_decorations = "yes";
      dynamic_background_opacity = "yes"; # Required for opacity to work
      font_size = 12;
      confirm_os_window_close = 0;
    };

    extraConfig = ''
      # Include file warna yang di-generate sama Noctalia/Matugen
      include ~/.config/kitty/themes/noctalia.conf
    '';
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome-themes-extra;
  };

  xdg.configFile."fastfetch/config.jsonc".text = builtins.readFile ./config/fastfetch/config.jsonc;

  # Aktifkan modul internal Home Manager
  programs.home-manager.enable = true;
}
