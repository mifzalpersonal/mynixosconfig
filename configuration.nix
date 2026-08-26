# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./helix.nix
      ./cysec.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  
  boot.loader.timeout = 0;

  boot.loader.efi.canTouchEfiVariables = true;

  systemd.services.NetworkManager-wait-online.enable = false;
  boot.kernelParams = [
    "quiet"                        
    #"splash"                       
    "loglevel=3"               

    "systemd.show_status=auto"     # Hanya tunjukkan status jika ada service error/hanging
    "rd.systemd.show_status=false"

    "boot.shell_on_fail"             # Tetap sediakan emergency shell kalau error parah

    "rd.udev.log_level=3"
    "udev.log_priority=3"

    "i915.enable_psr=1"   # Disable Panel Self Refresh (Fix flicker/stutter di UHD 620)
    "i915.fastboot=1"     # Seamless boot transition

    # FIX: Matikan probing serial port jadul 8250 (Eliminasi delay 5.5s ttyS0-S3)
    "8250.nr_uarts=0"

    # FIX: Nonaktifkan module TPM untuk memangkas delay initialization ~5.5s
    "tpm_tis.disable=1"

    # OPTIMASI BOOT DRIVE: Probing device SATA/SD Card secara asinkron (Eliminasi delay sda/sdb)
    "scsi_mod.use_blk_mq=1"
    "async_probe=all"
  ];

  boot.blacklistedKernelModules = [
    "tpm"
    "tpm_crb"
    "tpm_tis"
    "tpm_tis_core"
    "rtsx_usb"
    "rtsx_usb_sdmmc"
    "rtsx_usb_ms"
    "rtsx_pci"
    "rtsx_pci_sdmmc"
  ];

  #------------------THE START OF PLYMOMUHT---------------------
  #boot.plymouth = {
  #  enable = true;
  #  theme = "catppuccin-macchiato"; # Pilihan: catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
  #  
  #  themePackages = [
  #    (pkgs.catppuccin-plymouth.override {
  #      variant = "macchiato"; # Samakan varian warnanya di sini
  #    })
  #  ];
  #};
  #
  ## 1. Bikin Booting SANGAT Silent (Sembunyiin Teks Log Systemd)
  
  boot.consoleLogLevel = 0;
  
  boot.initrd = {
    systemd.enable = true;      # Wajib! Aktifkan systemd di stage 1 initrd biar ngebut
    compressor = "zstd";         # Gunakan zstd decompressor super cepat
    
    includeDefaultModules = false; # Matikan modul bawaan yang tidak terpakai

    kernelModules = [ 
      "ahci"        # Controller SATA buat SSD kamu (dev-sda)
      "sd_mod"      # Driver SCSI/SATA disk
      "btrfs"        # Filesystem root kamu (sesuaikan jika pakai btrfs/zfs)
      "i915"        # Early KMS display (tetap dipakai buat seamless boot)
    ];  

    verbose = false;
  };

  boot.initrd.compressorArgs = [ "-1" "--fast" ]; # Decompress jauh lebih cepat saat boot

  #------------------THE END OF PLYMOMUHT---------------------

  
  #apparently its home manager
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  systemd.services.home-manager-ciel = {
    wantedBy = lib.mkForce [ "default.target" ];
  };

  


  networking.hostName = "HIKVISION-NVR"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.scanRandMacAddress = false;
  networking.networkmanager.ethernet.macAddress = "preserve";
  networking.networkmanager.wifi.macAddress = "preserve";
  #networking.networkmanager.settings = {
    
    # dhcp = {
    #   send-hostname = true;
    # };

    # connection = {
    #   "ipv4.dhcp-send-hostname" = "iPhone";
    #   "ipv6.dhcp-send-hostname" = "iPhone";
    #   "ethernet.cloned-mac-address" = "A4:D1:8C:11:22:33";
    #   "wifi.cloned-mac-address" = "A4:D1:8C:44:55:66";
    # };
  #};

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  services.cloudflare-warp.enable = true;
  systemd.services.cloudflare-warp.wantedBy = lib.mkForce [];

  services.tailscale.enable = true;
  systemd.services.tailscaled.wantedBy = lib.mkForce [];
  

  programs.wayvnc.enable = true; 

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  hardware.bluetooth = {
  enable = true;
  powerOnBoot = false;
  settings = {
    General = {
      # Shows battery charge of connected devices on supported
      # Bluetooth adapters. Defaults to 'false'.
      #Experimental = true;
      # When enabled other devices can connect faster to us, however
      # the tradeoff is increased power consumption. Defaults to
      # 'false'.
      #FastConnectable = true;
    };
    Policy = {
      # Enable all controllers when they are found. This includes
      # adapters present on start as well as adapters that are plugged
      # in later on. Defaults to 'true'.
      AutoEnable = false;
      };
    };
  };

  #----------------OPTIMIZATIONNNNN-----------------------------
  boot.kernel.sysctl = {

    # TTL 65 + BBR Kernel Optimization
    "net.ipv4.ip_default_ttl" = 65;
    "net.ipv6.conf.all.hop_limit" = 65;


    # Tells kernel to swap aggressively to zRAM before touching SSD
    "vm.swappiness" = 180;
    # Mandatory for zRAM: processes 1 page (4KB) at a time instead of 16KB clusters
    "vm.page-cluster" = 0;
    # Prevents unnecessary page cache dropping when swapping
    "vm.vfs_cache_pressure" = 100;


    # MGLRU Optimization (Pemindaian memori presisi)
    "vm.lru_gen_config" = 3;


    # BBR TCP Congestion Control
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";

  };

  # 1. Pindahkan /tmp ke RAM (tmpfs) dengan limit 30%
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "30%";
  };

  # 2. Load Kernel Module untuk BBR
  boot.kernelModules = [ "tcp_bbr" ];
  #----------------OPTIMIZATIONNNNN-----------------------------


  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Masukkan ini di dalam configuration.nix lu

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  #services.xserver.windowManager.openbox.enable = true;
  programs.xwayland.enable = true;


  # Enable the GNOME Desktop Environment.
  services.displayManager.ly.enable = true;
  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = false;
  #services.gnome.core-apps.enable = false;
  #services.gnome.core-developer-tools.enable = false;
  #services.gnome.games.enable = false;

  environment.variables = {
     GSK_RENDERER = "gl";
     XCURSOR_THEME = "Bibata-Modern-Classic";
     XCURSOR_SIZE = "16";
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  
  # services.displayManager.defaultSession = "xfce";


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  security.rtkit.enable = true;
  services.pipewire = {
     enable = true;
     pulse.enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
   };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };
  services.upower.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      # Mulai ngecas kalau batre di bawah 75%, stop ngecas di 80%
      START_CHARGE_THRESH_BAT0 = 95;
      STOP_CHARGE_THRESH_BAT0 = 98;
      
      # Karena T480 punya dual battery (Bridge Battery System), atur juga BAT1
      START_CHARGE_THRESH_BAT1 = 75;
      STOP_CHARGE_THRESH_BAT1 = 80;

      CPU_SCALING_GOVERNOR_ON_AC = "powersave"; # Atau performance 
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      CPU_BOOST_ON_BAT = 0;
      CPU_BOOST_ON_AC = 1;

      # Atur Energy Performance Preference (EPP) biar pinter ngatur clock
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";

      # ==========================================
      # POWER LIMIT SETUP KHUSUS INTEL (TLP)
      # ==========================================
      # Saat dicolok Charger (AC): Kasih napas lega
       
      # PLATFORM_POWER_LIMIT_1_TIME_ON_AC = 28;
      # PLATFORM_POWER_LIMIT_1_POWER_ON_AC = 20000; # 25 Watt (dalam miliwatt)
      # PLATFORM_POWER_LIMIT_2_TIME_ON_AC = 28;
      # PLATFORM_POWER_LIMIT_2_POWER_ON_AC = 30000; # 35 Watt
      # 
      # # Saat Mode BATERAI (BAT): KUNCI DI 10 WATT BIAR GAK DROP!
      # 
      # PLATFORM_POWER_LIMIT_1_TIME_ON_BAT = 28;
      # PLATFORM_POWER_LIMIT_1_POWER_ON_BAT = 6000; # 10 Watt max
      # PLATFORM_POWER_LIMIT_2_TIME_ON_BAT = 28;
      # PLATFORM_POWER_LIMIT_2_POWER_ON_BAT = 6000; # 10 Watt max (no burst spike)

    };
  };

  #services.throttled = {
  #  enable = true;
  #  extraConfig = ''
  #    [GENERAL]
  #    Enabled = True
  #    Autoreload = True
  #    #Sysfs_Update_Rate_s: 5
  #
  #    [BATTERY]
  #    # KUNCI 7 WATT PAS BATERAI
  #    Update_Rate_s = 30
  #    PL1_Power_W: 7
  #    PL1_Time_s: 28
  #    PL2_Power_W: 7
  #    PL2_Time_s: 0.002
  #
  #    [AC]
  #    Update_Rate_s = 5
  #    # PAS DICOLOK CHARGER
  #    PL1_Power_W: 20
  #    PL1_Time_s: 28
  #    PL2_Power_W: 30
  #    PL2_Time_s: 0.002
#
  #    [UNDERVOLT.BATTERY]
  #    CORE: -100
  #    GPU: -25
  #    CACHE: -90
  #    UNCORE: -25
  #    ANALOGIO: 0
#
  #    [UNDERVOLT.AC]
  #    CORE: -100
  #    GPU: -25
  #    CACHE: -90
  #    UNCORE: -25
  #    ANALOGIO: 0
  #  '';
  #};
  
  #services.thinkfan = {
  #  enable = true;
  #  levels = [
  #    #[0 0 57]              # Fan OFF (0 RPM) sampai 57°C -> Bikin irit baterai pas idle
  #    #[2 46 68]             # Level 1 (~1200 RPM): Begitu nyala, ditahan luas dari 50°C - 68°C!
  #    #[3 58 74]             # Level 2 (~2000 RPM): Baru naik kalau > 68°C
  #    #[4 66 80]             # Level 4 (~3000 RPM): Baru naik kalau > 74°C
  #    #[6 72 84]             # Level 6 (~3500 RPM): Emergency > 80°C
  #    #["level auto" 82 100]
  #
  #    [0 0 57]              # OFF Total (0 RPM) dari 0°C sampai 57°C (Keinginan kamu!)
  #    ["level auto" 47 100] # Di atas 57°C, SERAHKAN KE BIOS (AUTO) sampai suhu turun lagi ke 48°C
  #  ];
  #};

  # Aktifkan UDisks2 (Backend buat kelola/mount disk tanpa root)
  services.udisks2.enable = true;

  # Aktifkan GVfs (Wajib buat Thunar biar sidebar-nya bisa baca disk, trash, dll)
  services.gvfs.enable = true;

  environment.sessionVariables = {
    
    # Paksa semua app GTK3/GTK4 pakai Dark Theme
    GTK_THEME = "catppuccin-mocha-blue-standard";
  
    # Aktifkan fitur modern Thunar (thumbnail & preview)
    #GDK_BACKEND = "wayland,x11";

    # Memaksa portal GNOME mengenali environment
    # XDG_SESSION_TYPE = "wayland";
  };
  # programs.firefox.enable = true;
  #programs.hyprland.enable = true;
  
  programs.niri.enable = true;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
  ];
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     neovim
     gcc
     tree-sitter        # CLI Tree-sitter
     ripgrep
     fd
     lazygit
     fzf
     thunar-archive-plugin  # Klik kanan -> Extract / Compress
     thunar-volman        # Auto mount USB / Flashdisk
     brightnessctl
     nh
     unzip
     p7zip
     unrar
     
     # Thumbnail generator (Biar gambar, video, & PDF keliatan gambarnya)
     tumbler                     # Engine preview gambar
     ffmpegthumbnailer           # Preview video
     poppler-utils               # Preview PDF
     file-roller                 # App GUI pendukung ekstraksi zip
     xfconf
     libnotify
     
    #python pip
    (python3.withPackages (ps: with ps; [
      pygobject3
    ]))
    gobject-introspection

     #larp
     btop
     fastfetch
     yazi
     tty-clock
     pipes
     lavat
     eza
     bat
     s-tui
     chafa
     #------
     
     
     brave
     alacritty
     kitty
     steam
     thunar
     discord
     #kdePackages.dolphin
     niri
     fuzzel
     libreoffice-fresh
     flatpak
     file
     obs-studio
     ventoy-full
     modprobed-db
     
     #sehari hari alias bloat
     gnome-calculator      # Kalkulator GTK simpel & responsif
     cheese                # App Kamera (Webcam viewer)
     gnome-clocks          # Jam, Timer, Stopwatch, Alarm
     gnome-text-editor     # Text editor GUI ringan
 
     # --- GAMING & FUN ---
     gnome-chess           # Game Catur (vs AI/GNU Chess)
     gnuchess              # Engine AI catur biar gnome-chess bisa dimainin
     aisleriot             # Solitaire / Kartu klasik bawaan
 
     # --- MEDIA & SYSTEM MANAGEMENT ---
     loupe                 # Image Viewer modern (replacement EOG di Wayland)
     evince                # PDF Reader
     baobab                # Disk Usage Analyzer (buat cek kapasitas SSD)
     vlc
     nautilus
     blueman
     gparted

     #mau maen gaming ah
     ppsspp
     pcsx2

     cava
     xwayland-satellite #its for xxwayland so steam can run
     bazaar
     ollama
     obsidian
     #ani-cli
     ncdu
     img2pdf
     imagemagick
     mangohud


     #driver checkers
     intel-gpu-tools
     mesa-demos
     vulkan-tools
     libva-utils

     #lib
     mpv
     aria2
     ffmpeg
     yt-dlp
     ntfs3g
     pciutils
     usbutils

    #cursor
    bibata-cursors
    adwaita-icon-theme 

    #project iwnboat
    #labwc

    # devs thingy
     laravel
     mariadb
     php
     nodejs
     clang
     python313
     vscode
     go
     docker
     winboat
     python313Packages.pip
     llama-cpp
     aider-chat-full
     php84
     php84Packages.composer
     tmux
     helix
     wayvnc
     zeal
     kdePackages.kdenlive
    # --------

    #(wrapOBS {
    #  plugins = with obs-studio-plugins; [
    #    obs-pipewire-audio-capture
    #    wlrobs
    #    ];
    #})
  ];

  #-------------DEVSSS-------------
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  systemd.services.mysql.wantedBy = lib.mkForce [];

  services.flatpak.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # Biar gak ngerem booting
  };

  services.ollama = {
    enable = false;
    host = "0.0.0.0";
    port = 11434;
  };
  #--------------------------------

  
  fonts.packages = with pkgs; [
     noto-fonts
     noto-fonts-cjk-sans       # Jurus anti kotak-kotak Jepang
     font-awesome              # Ikon widget Caelestia
     nerd-fonts.jetbrains-mono # Font terminal
     corefonts
     nerd-fonts.fira-code
     monocraft
  ];

   environment.shellAliases = {
    
    #gen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    #rb = "sudo nixos-rebuild switch --flake /etc/nixos#nix";
    #rbf = "sudo nixos-rebuild switch --no-reexec --flake /etc/nixos#nix";
    #rbo = "sudo nixos-rebuild switch --no-reexec --option substitute false --flake /etc/nixos#nix";
    #gc = "sudo nix-collect-garbage -d -v";  
    #up = "nix flake update /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos#nix";

    gen = "nh os info";
    rb  = "nh os switch /etc/nixos#nix -v";
    rbf = "nh os switch --no-reexec /etc/nixos#nix";
    rbo = "nh os switch --no-reexec -- --option substitute false /etc/nixos#nix";
    gc  = "nh clean all";
    up  = "nh os switch --update /etc/nixos#nix";

    ls = "eza --icons --group-directories-first";
    ll = "eza -l --icons --group-directories-first";
    tree = "eza --tree --icons";
    bcat = "bat";
    cd = "z";
    roblox = "flatpak run --env=GTK_THEME=Adwaita --env=GDK_BACKEND=x11 org.vinegarhq.Sober";
    kipas = "cat /proc/acpi/ibm/fan";
    ghidrax11 = "GDK_BACKEND=x11 _JAVA_AWT_WM_NONREPARENTING=1 ghidra";
  };

  # --------------APP SETTINGS---------------
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Aktifkan Gamescope
  programs.gamescope = {
    enable = true; 
  };

  programs.fish.enable = true;

  services.tumbler.enable = true;
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Wajib buat Steam & Proton (32-bit games/libraries)

    # Driver akselerasi Intel (VA-API & Vulkan)
    

    extraPackages = with pkgs; [
      intel-media-driver # Driver VA-API resmi Intel buat Gen 9+ (i5-8250U)
      vulkan-validation-layers
      intel-vaapi-driver
      vulkan-tools
      libvdpau-va-gl
    ];
    
    # Versi 32-bit driver Intel biar Steam 32-bit rendering-nya jos
    extraPackages32 = with pkgs; [
      intel-media-driver
    ];
  };



  #xdg.portal = {
  #  enable = true;
  #  #wlr.enable = true;
  #  extraPortals = [
  #    pkgs.xdg-desktop-portal-gtk
  #    #pkgs.xdg-desktop-portal-wlr
  #    pkgs.xdg-desktop-portal-gnome
  #  ];
  #
  #  config = {
  #    common = {
  #      default = [ "gnome" "gtk" ]; # "wlr"
  #    };
  #  niri = {
  #    default = lib.mkForce [ "gnome" "gtk" ];
  #  };
  #  };

    #config.niri = {
    #  # Use GNOME for screen sharing (Niri implements the Mutter interface)
    #  "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
    #  "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
    #
    #  # Use GTK for file choosers (avoids Nautilus dependency)
    #  "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    #  "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
    #};
    #
    #config.common = {
    #  "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
    #  "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
    #};
  #};

  #environment.sessionVariables.XDG_CURRENT_DESKTOP = "niri:GNOME";

  #systemd.user.services.xdg-desktop-portal-gnome.environment = {
  #  WAYLAND_DISPLAY = "wayland-1";
  #  XDG_CURRENT_DESKTOP = "niri:GNOME";
  #  XDG_SESSION_DESKTOP = "niri";
  #};

  

  # (Opsional) Nyalain GameMode biar CPU i5-8250U lu gak ketahan power saving pas main game
  programs.gamemode.enable = true;

  # -----------------------------------------

  # Enable undervolt service for ThinkPad T480 (Kaby Lake R)
  services.undervolt = {
    enable = true;
    temp = 85;
    
    # Voltage Offset (dalam mV, pake angka negatif)
    coreOffset = -100;   # CPU Core
    gpuOffset = -25;     # Integrated GPU (Intel UHD 620)
    uncoreOffset = -25;    # iGPU Unslice / Uncore (-25.4 mV)
    
    useTimer = true;
    # Pengaturan Power Limit (Optional, biar makin adem)
    
    p1 = {
      limit = 20;
      window = 28;
    }; 
    
    p2 = { 
      limit = 30;
      window = 28;
    }; 
  };
  
  users.users.ciel = {
    isNormalUser = true;
    description = "ciel";
    shell = pkgs.fish; # <-- TAMBAHKAN BARIS INI!
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" "render" "wireshark"];
  };

  
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-40.10.5"
      "ventoy-1.1.12"
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    eval-cache = true;
    #Otomatis bersihkan file installer corrupt / setengah download
    keep-outputs = false;
    keep-derivations = false;

    http-connections = 50; #50 orang kerja free labor
    max-substitution-jobs = 128;

    # MASUKKAN CACHE XDDXDD DI SINI:
    substituters = [
      "https://cache.nixos.org"
      "https://nyx.chaotic.cx"
      #"https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "chaotic-nyx.cachix.org-1:1g/B464uu16beB4y9RAG05oYgKmg8C8y6jvgfL/o+B4="
      #"lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  }; 

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ]; # Menjalankan hardlink deduplication seminggu sekali di background
  };


  # --------------CACHY KERNEL-------------------
  #nixpkgs.overlays = [
  #  inputs.nix-cachyos-kernel.overlays.pinned
  #];

  boot.supportedFilesystems = [ "ntfs" "exfat" "vfat" ];
  security.polkit.enable = true;
  
  #boot.kernelPackages = pkgs.linuxPackages_zen_latest;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  #boot.kernelPackages = pkgs.linuxPackages_cachyos;
  #boot.kernelPackages = pkgs.cachyoskernels.linuxPackages-cachyos-bore-lto-x86_64-v3;

  # 1. Daftarkan Overlay xddxdd
  #nixpkgs.overlays = [
  #  inputs.nix-cachyos-kernel.overlays.pinned
  #];

  # 2. Panggil Kernel BORE LTO v3
  #boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;
  
  # Mengunci & me-override paket kernel LTS
  # =========================================================================
  # 1. RACIKAN KERNEL TKG-BORE LTS 6.6 (LLVM / ThinLTO / x86-64-v3)
  # =========================================================================
  #boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_6.extend (self: super: {
  #  kernel = super.kernel.override {
  #    # Compiler LLVM / Clang
  #    stdenv = pkgs.llvmPackages_latest.stdenv;
  #    
  #    structuredExtraConfig = with lib.kernel; {
  #      # BORE Scheduler
  #      SCHED_BORE = yes;
  #      
  #      # CPU Microarchitecture Tuning (Target Intel Gen 8 / Core2)
  #      MCORE2 = yes;
  #      GENERIC_CPU = no;
  #      
  #      # ThinLTO Optimization
  #      LTO_NONE = no;
  #      LTO_CLANG_THIN = yes;
  #      
  #      # Low-Latency & Input Speed (Full Preemption + 1000Hz)
  #      PREEMPT_SERVER = no;
  #      PREEMPT_RT = no;
  #      PREEMPT = lib.mkForce yes;
  #      HZ_1000 = yes;
  #      
  #      # Gaming & Syscall Sync (Futex2 / Fsync)
  #      FUTEX = yes;
  #      FUTEX_PI = yes;
  #      
  #      # Google BBR Network Speedup
  #      TCP_CONG_BBR = yes;
  #      DEFAULT_BBR = yes;
  #    };
  #
  #    # Patch BORE Resmi CachyOS / TKG buat LTS 6.6
  #    kernelPatches = super.kernel.kernelPatches ++ [
  #      {
  #        name = "bore-cachy-patch";
  #        patch = pkgs.fetchpatch {
  #          #url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/master/6.6/0001-bore-cachy.patch";
  #          #url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/master/6.6/bore/0001-bore-cachy.patch";
  #          #url = "https://raw.githubusercontent.com/fireburn/survivor-kernel-patches/main/6.6/0001-bore-cachy.patch";
  #          sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Auto-fix pas pertama build
  #        };
  #      }
  #    ];
  #  };
  #});



  #services.scx = {
  #  enable = true;
  #};

  #services.scx.enable = true;
  #services.scx.scheduler = "scx_bpfland";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 70; # Pakai alokasi max 50% dari total RAM fisik kamu
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  
  networking.firewall = {
    enable = true;
    ## Port TCP wajib Sunshine & GameStream
    allowedTCPPorts = [ 5900 ];
    ## Port UDP wajib Sunshine (GameStream audio/video/control)
  };

  #networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

