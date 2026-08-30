{
  description = "Config NixOS + Flakes + Home Manager super gokil";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nvf.url = "github:notashelf/nvf";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #qylock.url = "github:Darkkal44/qylock";

  };

  outputs ={ self, nixpkgs, home-manager, nvf, ... } @inputs: #qylock
    {
      nixosConfigurations = { nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            #qylock.nixosModules.default
            ({ pkgs, ... }: {
              
            })

            #-----------------
            ./configuration.nix
            nvf.nixosModules.default

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup"; # <-- Tambahkan baris ini!

              # TAMBAHKAN BARIS INI:
              home-manager.extraSpecialArgs = { inherit inputs; };

              home-manager.users.ciel = import ./home.nix;
            }
          ];
        };
      };
    };
}
