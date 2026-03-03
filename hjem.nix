{ config, lib, pkgs, inputs, ... }:

{
programs.dconf.profiles.user.databases = [
 {
  settings = 
  { "org/gnome/desktop/interface" = {
   gtk-theme = "adw-gtk3"; 
   };
  };
 } 
];
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
       ".config/ironbar/config.yaml".source = ./ironbar.yaml;
       ".config/ironbar/style.css".source = ./ironbar.css;
      };
    };
  };
}
