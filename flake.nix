{
  description = "Config NixOS + Flakes + Home Manager super gokil";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qylock.url = "github:Darkkal44/qylock";

  };

  outputs = { self, nixpkgs, home-manager, qylock, ... }@inputs: {  
    nixosConfigurations = { nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
        qylock.nixosModules.default
        ({ pkgs, ... }: {
          services.displayManager.sddm = {
            enable = true;
            wayland.enable = true;

            settings = {
              Theme = {
                CursorTheme = "Bibata-Modern-Classic"; # Atau "Adwaita" / "breeze_cursors"
                CursorSize = "24";
              };
              General = {
                EnableHiDPI = "true";
                # Memaksa Wayland compositor bawaan SDDM (KWin/Weston) menampilkan kursor
                DisplayServer = "wayland";
              };
            };
          };

          services.displayManager.defaultSession = "niri";
          
          programs.qylock = {
            enable = true;
            theme = "osu";          # any directory name under themes/
            sddm.enable = true;             # installs theme + sets it active (default)
            quickshell.enable = true;       # adds `qylock-lock` to PATH (default)

            # Optional per-theme tweaks (replaces the interactive prompts):
            themeOptions = {
              terraria.backgroundMode = "time";              # time | random | static
              Genshin.backgroundMode = "time";
              clockwork.orbital = { themeMode = "dark"; enableWindup = true; };
              osu.gameMode = "menu";                         # menu | game
            };
          };
        })

          #-----------------
          ./configuration.nix
          ./noctalia.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup"; # <-- Tambahkan baris ini!
            
            home-manager.users.ciel = import ./home.nix;
          }
        ];
      };
    };
  };
}