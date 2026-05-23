{
  description = "Config NixOS + Flakes + Home Manager super gokil";

  inputs = {
    # Mengambil paket dari Nixpkgs unstable (paling update)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # 1. TAMBAHKAN BARIS SAKTI INI DI BLOK INPUTS
    caelestia.url = "github:caelestia-dots/cli";

    # Mengambil sumber paket dari Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # 'nixos' ini sesuai dengan hostname laptop lu saat ini
      nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
	  {
    	     home-manager.extraSpecialArgs = { inherit inputs caelestia; }; # <--- Pastikan ada 'caelestia' atau 'inputs' di sini
  	  }

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
