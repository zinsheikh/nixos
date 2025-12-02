{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
   # add unstabke.xyzpackage instead of pkgs.xyzpackage to get the unstabel version
   # dont forget to add unstable to the input parameter (its the {config, lib, pkgs, unstable, ...}: thing
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
   # niri.url = "github:sodiboo/niri-flake";

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
   #niri,
  ... }: let
    system = "x86_64-linux";
    unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
  in {

    # replace 'joes-desktop' with your hostname here.
    nixosConfigurations.penguin = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs; inherit unstable;};
      modules = [ ./configuration.nix ./noctalia.nix];
    };
  };
}

