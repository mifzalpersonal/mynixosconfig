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
  
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: { 
    nixosConfigurations = {
      # 'nix' sesuai dengan hostname laptop lu saat ini
      nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix
          ./noctalia.nix

          
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