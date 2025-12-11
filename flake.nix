{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
   # add unstabke.xyzpackage instead of pkgs.xyzpackage to get the unstabel version
   # dont forget to add unstable to the input parameter (its the {config, lib, pkgs, unstable, ...}: thing
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    niri.url = "github:sodiboo/niri-flake";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

   # CachyOS kernel for better system optimisations
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

   # quickshell = {
   #   url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
   #   inputs.nixpkgs.follows = "nixpkgs-unstable";
   # };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    #  inputs.quickshell.follows = "quickshell"; #this is deprecated, noctalia swiched to nixpgks quickshell
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
     niri,
     home-manager,
     noctalia,
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
	#./noctalia.nix
        # inputs.noctalia.nixosModules.default

          inputs.niri.nixosModules.niri
          {
            nixpkgs.overlays = [niri.overlays.niri];
          }

	 inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.penguin = ./home.nix;
            home-manager.extraSpecialArgs = {inherit inputs;};

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }

      ];
    };
  };
}

