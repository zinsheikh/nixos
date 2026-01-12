{pkgs, inputs, nvf, ...}:
{

  imports = [ inputs.nvf.nixosModules.default ];
  
  # vim.languages.nix.lsp.enable = true;  

  programs.nvf = {
    enable = true;
    
    # Your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim.viAlias = false;
      vim.vimAlias = true;
      vim.lsp = {
        enable = true;
      };
      vim.languages.nix.lsp.enable = true;
      vim.languages.zig.lsp.enable = true;
    };
  };
}
