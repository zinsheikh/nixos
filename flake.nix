{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
   # add unstabke.xyzpackage instead of pkgs.xyzpackage to get the unstabel version
   # dont forget to add unstable to the input parameter (its the {config, lib, pkgs, unstable, ...}: thing
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
   # niri.url = "github:sodiboo/niri-flake";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
   outputs = inputs@{ 
     self, 
     nixpkgs,
     nixpkgs-unstable,
   # niri,
     home-manager,
    ... }: 
    let
    system = "x86_64-linux";
    unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
  in {

    # replace 'joes-desktop' with your hostname here.
    nixosConfigurations.penguin = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs; inherit unstable;};
      modules = [ 
	./configuration.nix 
	./noctalia.nix

	 home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.penguin = ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }

      ];
    };
  };
}

