{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    niri.url = "github:sodiboo/niri-flake";
  };
  outputs = { self, nixpkgs, niri, }: {
    # replace 'joes-desktop' with your hostname here.
    nixosConfigurations.penguin = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}

