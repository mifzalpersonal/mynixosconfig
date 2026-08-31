{
  config,
  pkgs,
  inputs,
  ...
}: # caelestia

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

  # Enable Zsh & Plugins
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    completionInit = "autoload -U compinit && compinit -u";

    # Memuat plugin tambahan langsung dari Nixpkgs
    plugins = with pkgs; [
      {
        name = "fzf-tab";
        src = "${zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-vi-mode";
        src = "${zsh-vi-mode}/share/zsh-vi-mode";
      }
      {
        name = "zsh-you-should-use";
        src = "${zsh-you-should-use}/share/zsh-you-should-use";
      }
      {
        name = "forgit";
        src = "${zsh-forgit}/share/zsh-forgit";
      }
      {
        name = "zsh-expand";
        src = pkgs.fetchFromGitHub {
          owner = "MenkeTechnologies";
          repo = "zsh-expand";
          rev = "master";
          hash = "sha256-fyHYAitwT8VSwdc4U2WcwjW9iNCT+8u57ndGeygP1JE="; # Nix bakal pancing hash resminya pas 'rb'
        };
      }
      {
        name = "zsh-auto-notify";
        file = "auto-notify.plugin.zsh"; # <-- INI DITAMBAHIN!
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-auto-notify";
          rev = "master";
          hash = "sha256-s3TBAsXOpmiXMAQkbaS5de0t0hNC1EzUUb0ZG+p9keE="; # Nix bakal pancing hash resminya pas 'rb'
        };
      }
      {
        name = "evalcache";
        src = pkgs.fetchFromGitHub {
          owner = "mroth";
          repo = "evalcache";
          rev = "v1.0.3"; # atau branch "master"
          hash = "sha256-CN9dnSt9kc5AEkWnbtjyv+DCQZ08Ifmac5wELqve17U="; # Salin hash resmi dari error log saat 'rb'
        };
      }
    ];

    #Inisialisasi ekstra untuk Zsh (termasuk fungsi kustom dari Fish sebelumnya)
    initContent = ''

      # Aktifkan auto-completion tanpa mempedulikan huruf besar/kecil (case-insensitive)
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      # Inisialisasi pay-respects sebagai 'fuck'
      eval "$(pay-respects zsh --alias fuck)"

      # Matikan error globbing zsh kalau nemu karakter #
      unsetopt nomatch

      # Matikan peringatan compfix Zsh
      ZSH_DISABLE_COMPFIX="true"

      # --- EVALCACHE (Mempercepat load Starship & Zoxide) ---
      _evalcache starship init zsh
      _evalcache zoxide init zsh

      # --- CONFIGURATION FOR AUTO-NOTIFY ---
      AUTO_NOTIFY_THRESHOLD=5
      
      # Format teks notifikasi bawaan plugin-nya
      AUTO_NOTIFY_TITLE="Process Finished"
      AUTO_NOTIFY_BODY="'%command' executed in %elapsed s • Exit: %exit_code"
      # Kalau mau abaikan command tertentu
      AUTO_NOTIFY_IGNORE=("nvim" "sudo nvim" "nano" "btop" "s-tui" "sudo btop" "sudo s-tui" "hx" "sudo hx")


      # Fungsi Turbo dari Fish kamu yang di-porting ke Zsh/POSIX
      turbo() {
        echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
        echo "balance_performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
        "$@"
        echo "balance_power" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
        echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo
      }
    '';
  };

  programs.starship = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
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

      enable_audio_bell = true;
      bell_path = "/home/ciel/Music/persona.wav";

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
    enableZshIntegration = true;
  };

  # Integrasi FZF (fuzzy finder buat nyari file/history super cepat)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
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
