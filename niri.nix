{  
  pkgs,
  inputs,
  config,
  nixosConfig,
  ...
}: {
  imports = [
   ./niri/keybinds.nix
# add more shit her when needed

  ];
  programs.niri.settings = {
    prefer-no-csd = true;
    layout = {
    shadow.enable = true;
    };
    spawn-at-startup = [{command = ["swaync"];}];
    outputs.eDP-1.mode = {
    width = 2256;
    height = 1504;
    refresh = 60.0;
    };
    input = {
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "0%";
      };
      keyboard.xkb =  with nixosConfig.services.xserver.xkb; {
        inherit variant layout options;
      };
 };


    window-rules = [
      {
        clip-to-geometry = true; 
        geometry-corner-radius = {
        bottom-left = 5.0;
        bottom-right = 5.0;
        top-left = 5.0;
        top-right = 5.0;
        };
      }
  ];
 };
}
