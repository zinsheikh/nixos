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
    layout.shadow.enable = true;
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
        matches = [ { app-id = "authentication-agent-1|pwvucontrol"; } ];
        open-floating = true;
      }
  ];
 };
}
