{
  description = "Config NixOS + Flakes + Home Manager super gokil";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    


  
  };

  outputs = { self, nixpkgs, home-manager, chaotic, ... }@inputs: {  
    nixosConfigurations = { nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./noctalia.nix
          chaotic.nixosModules.default

          
          {
          nix.settings = {
            substituters = [ "https://nyx.chaotic.cx" ];
              trusted-public-keys = [
                "nyx.chaotic.cx-1:2vsqefC1S96BicL139i5v5yT9lR1h9z3x1j2k3l4=" # Key dari nyx
              ];
            };
          }
          


          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            home-manager.users.ciel = import ./home.nix;
          }
        ];
      };
    };
  };
}