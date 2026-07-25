# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nix"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings = {
    General = {
      # Shows battery charge of connected devices on supported
      # Bluetooth adapters. Defaults to 'false'.
      Experimental = true;
      # When enabled other devices can connect faster to us, however
      # the tradeoff is increased power consumption. Defaults to
      # 'false'.
      FastConnectable = true;
    };
    Policy = {
      # Enable all controllers when they are found. This includes
      # adapters present on start as well as adapters that are plugged
      # in later on. Defaults to 'true'.
      AutoEnable = true;
      };
    };
  };

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
  programs.xwayland.enable = true;


  # Enable the GNOME Desktop Environment.
  # services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = false;
  #services.gnome.core-apps.enable = false;
  #services.gnome.core-developer-tools.enable = false;
  #services.gnome.games.enable = false;

  environment.variables = {
     WLR_NO_HARDWARE_CURSORS = "1";
     GSK_RENDERER = "gl";
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
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      # Mulai ngecas kalau batre di bawah 75%, stop ngecas di 80%
      START_CHARGE_THRESH_BAT0 = 60;
      STOP_CHARGE_THRESH_BAT0 = 80;
      
      # Karena T480 punya dual battery (Bridge Battery System), atur juga BAT1
      START_CHARGE_THRESH_BAT1 = 60;
      STOP_CHARGE_THRESH_BAT1 = 80;
    };
  };

  # programs.firefox.enable = true;
  #programs.hyprland.enable = true;
  programs.niri.enable = true;
  services.displayManager.ly.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     neovim

     #larp
     btop
     fastfetch
     yazi
     tty-clock
     pipes
     lavat
     #------

     brave
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
     cava
     xwayland-satellite #its for xxwayland so steam can run

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
    # --------
  ];

  #-------------DEVSSS-------------
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.flatpak.enable = true;

  virtualisation.docker = {
    enable = true;
  };
  #--------------------------------


  fonts.packages = with pkgs; [
     noto-fonts
     noto-fonts-cjk-sans       # Jurus anti kotak-kotak Jepang
     font-awesome              # Ikon widget Caelestia
     nerd-fonts.jetbrains-mono # Font terminal
     corefonts
  ];

   environment.shellAliases = {
    gen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";

    rb = "sudo nixos-rebuild switch --flake /etc/nixos#nix";
    #up = "sudo nixos-rebuild switch --upgrade --flake /etc/nixos#nix";
    gc = "sudo nix-collect-garbage -d -v";
    up = "nix flake update /etc/nixos && sudo nixos-rebuild switch --flake /etc/nixos#nix";
  };

  # --------------APP SETTINGS---------------
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # -----------------------------------------

  # Enable undervolt service for ThinkPad T480 (Kaby Lake R)
  services.undervolt = {
    enable = true;
    
    # Voltage Offset (dalam mV, pake angka negatif)
    coreOffset = -100;   # CPU Core
    gpuOffset = -25;     # Integrated GPU (Intel UHD 620)
    uncoreOffset = -25;    # iGPU Unslice / Uncore (-25.4 mV)
    
    useTimer = true;
    # Pengaturan Power Limit (Optional, biar makin adem)
    # packagePowerLimitP1 = 25; # Short term boost (Watts)
    # packagePowerLimitP2 = 15; # Long term sustained limit (Watts)
  };
  
  users.users.ciel = {
    isNormalUser = true;
    description = "ciel";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker"];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    auto-optimise-store = true;
  }; 

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };


  # --------------CACHY KERNEL-------------------
  #nixpkgs.overlays = [
  #  inputs.nix-cachyos-kernel.overlays.pinned
  #];

  #boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-latest;

  #nix.settings = {
  #  substituters = [ 
  #    "https://cache.nixos.org" 
  #    "https://attic.xuyh0120.win/lantian" 
  #  ];
  #  trusted-public-keys = [ 
  #    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" 
  #  ];
  #};
  # --------------------------------------


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
  # networking.firewall.enable = false;

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

