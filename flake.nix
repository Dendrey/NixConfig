{
  description = "Dendrey’s NixOS + Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }: {
    nixosConfigurations.DendreyNixLaptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/laptop/configuration.nix
        home-manager.nixosModules.home-manager

        {
          nixpkgs.overlays = [
            (final: prev: {
              quickshell = nixpkgs-unstable.legacyPackages.${prev.system}.quickshell;
            })
          ];

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.dendrey = import ./home/dendrey/home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
      ];
    };
  };
}
