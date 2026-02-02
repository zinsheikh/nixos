{ config, lib, pkgs, inputs, ... }:

{
hjem.users = {
    penguin = {
      # enable = true; # This is not necessary, since enable is 'true' by default
      user = "penguin"; # this is the name of the user
      directory = "/home/penguin"; # where the user's $HOME resides

      systemd.enable = false;

      files ={
       ".config/starship.toml".source = ./starship.toml;
       ".config/alacritty/alacritty.toml".source = ./alacritty.toml;
       ".config/fish/config.fish".source = ./config.fish;
      };
    };
  };
}
