{ config, pkgs, inputs,  ... }: #caelestia

{
  home.username = "ciel";
  home.homeDirectory = "/home/ciel";

  # Sinkron dengan stateVersion di configuration.nix lu
  home.stateVersion = "25.11"; 
  

  fonts.fontconfig.enable = true;
  # Tempat naruh aplikasi khusus user lu nanti
  home.packages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
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
  };# kitty +kitten icat --place 20x20@0x0 "$random_img"
    # set random_img (random choice /etc/nixos/genshin-chibis/*.png)
    #   if test -f "$random_img"
    #       chafa --size=20x20 $random_img
    #   end

     #function pinging
     #while true
     #  if curl -sI --max-time 5 http://connectivitycheck.gstatic.com/generate_204 
     #      echo "[(date +'%H:%M:%S')] Keep-alive sent"
     #  else
     #      echo "[(date +'%H:%M:%S')] Failed"
     #  end
     #  sleep 180
     #end

     #function turbo
     #
     #  echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
     #  echo "balance_performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference   
     #
     #  $argv
     #  
     #  echo "power" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference   
     #  echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
     #
     #end

  

  programs.starship = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    #font = {
    #    name = "Monocraft";
    #};
    # These settings are written to ~/.config/kitty/kitty.conf by Home Manager
    # Noctalia will NOT overwrite these because we are not letting it manage the main file
    settings = {
      background_opacity = "0.75";
      hide_window_decorations = "yes";
      dynamic_background_opacity = "yes"; # Required for opacity to work
      font_size = 12;
      confirm_os_window_close = 0;
      disable_ligatures = "never";
      
      # --- EFEK REAKTIF / TRAIL (Fitur Kitty Terbaru) ---
      # Mengaktifkan efek ekor/jejak saat kursor bergerak/ketik
      cursor_trail = "3";
      # Kecepatan memudar efek ekor (start_decay end_decay)
      cursor_trail_decay = "0.1 0.4";
      # Ambang batas jarak minimal (pixel) kursor bergerak untuk memicu efek trail
      cursor_trail_start_threshold = "1";
      
    };

    extraConfig = ''
      # Include file warna yang di-generate sama Noctalia/Matugen
      include ~/.config/kitty/themes/noctalia.conf
    '';
  };
  

  # Integrasi Zoxide (pengganti 'cd' yang cerdas)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Integrasi FZF (fuzzy finder buat nyari file/history super cepat)
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.gnome-themes-extra;
    enable = true;
  };

  # ------------------------ SLOPPPPPPPPPPPP -------------------
  gtk = {
  enable = true;
  gtk4.theme = null;
  
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
  platformTheme.name = "gtk3";
  style.name = "Bibata-Modern-Classic";
};

xdg.userDirs = {
  enable = true;
  createDirectories = true; # Otomatis bikin folder kalau belum ada
  setSessionVariables = false;
  download = "${config.home.homeDirectory}/Downloads";
  pictures = "${config.home.homeDirectory}/Pictures";
};

#xdg.configFile."user-dirs.conf" = {
#  text = "enabled=True";
#  force = true;
#};

#------------------SLOPPPPPPPPPPPPPPPP----------------------

home.sessionVariables = {
    # Memaksa SEMUA aplikasi Java Swing/AWT (Ghidra, Burp, NetBeans, dll) 
    # pake kompatibilitas XWayland tanpa bikin window transparan/blank.
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

#xdg.configFile."fastfetch/config.jsonc".text = builtins.readFile ./config/fastfetch/config.jsonc;
xdg.configFile."fastfetch/config.jsonc".source = ./config/fastfetch/config.jsonc;
xdg.configFile."starship.toml".source = ./config/starship/starship.toml;
xdg.configFile."niri/config.kdl".source = ./config/niri/config.kdl;
xdg.configFile."helix/config.toml".source = ./config/helix/config.toml;
xdg.configFile."helix/languages.toml".source = ./config/helix/languages.toml;
#xdg.configFile."xdg-desktop-portal/portals.conf".source = ./config/xdg-desktop-portal/portals.conf;

  # Aktifkan modul internal Home Manager
programs.home-manager.enable = true;

}
