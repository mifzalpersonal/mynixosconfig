{
  description = "Config NixOS + Flakes + Home Manager super gokil";

  inputs = {
    # Mengambil paket dari Nixpkgs unstable (paling update)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Mengambil sumber paket dari Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Caelestia CLI / Shell Source
    caelestia.url = "github:caelestia-dots/cli";
  };

  outputs = { self, nixpkgs, home-manager, caelestia, ... }@inputs: {
    nixosConfigurations = {
      # 'nix' sesuai dengan hostname laptop lu saat ini
      nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix

          # Integrasikan Home Manager ke dalam Flake sistem
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            # Ini tempat ngirim variabel 'caelestia' ke dalam home.nix dengan bener
            home-manager.extraSpecialArgs = { inherit inputs caelestia; };
            
            home-manager.users.ciel = import ./home.nix;
          }
        ];
      };
    };
  };
}