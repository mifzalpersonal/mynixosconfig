{
  description = "Config NixOS + Flakes + Home Manager super gokil";

  inputs = {
    # Mengambil paket dari Nixpkgs unstable (paling update)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Mengambil sumber paket dari Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixConfigurations = {
      # 'nixos' ini sesuai dengan hostname laptop lu saat ini
      nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix

          # Integrasikan Home Manager ke dalam Flake sistem
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
