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

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting "" # Matikan pesan greeting pembuka bawaan Fish
    '';
  };

  programs.starship = {
    enable = true;
    # Integrasi otomatis ke fish
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    # These settings are written to ~/.config/kitty/kitty.conf by Home Manager
    # Noctalia will NOT overwrite these because we are not letting it manage the main file
    settings = {
      background_opacity = "0.64";
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
    enable = true;
  };

  gtk = {
  enable = true;
  
  # Paksa GTK3 & GTK4 baca settingan Dark Mode
  gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };
  gtk4.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };

  # Icon Theme modern (biar folder & file di Thunar gak buruk rupa)
  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };

  # Theme GTK yang kompatibel (Catppuccin Mocha / Nord)
  theme = {
    name = "catppuccin-mocha-blue-standard";
    package = pkgs.catppuccin-gtk.override {
      accents = [ "blue" ];
      size = "standard";
      variant = "mocha";
    };
  };
};

# Bikin Qt app / xdg-desktop-portal ikut warna GTK
qt = {
  enable = true;
  platformTheme.name = "gtk";
  style.name = "adwaita-dark";
};

xdg.configFile."fastfetch/config.jsonc".text = builtins.readFile ./config/fastfetch/config.jsonc;

  # Aktifkan modul internal Home Manager
programs.home-manager.enable = true;

}
