{pkgs, ...}:

{
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
