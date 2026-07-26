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

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release"; 
    #https://github.com/xddxdd/nix-cachyos-kernel


  
  };

  outputs = { self, nixpkgs, home-manager, nix-cachyos-kernel, ... }@inputs: {  
    nixosConfigurations = { nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./noctalia.nix

          ({ pkgs, ... }:{
            

            # Set CachyOS Kernel
            boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.x86_64-linux.linuxPackages-cachyos-bore-x86_64-v3;
          })

          
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