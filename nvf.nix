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
      vim.languages.nix.enable = true;
      vim.languages.zig.enable = true;
      vim.languages.go.enable = true;
      vim.syntaxHighlighting = true;
      vim.autocomplete.blink-cmp.enable = true;

      vim.lsp = {
        enable = true;
      };
    };
  };
}
