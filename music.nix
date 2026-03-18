{pkgs, ...}:

{
 musnix.enable = true;

  environment.systemPackages = with pkgs; [
    qjackctl
    zrythm
    cardinal
    lsp-plugins
    zynaddsubfx
    giada
    guitarix
    hydrogen
  ];
}
