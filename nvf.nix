{ pkgs, ... }:

{
  programs.nvf = {
    enable = true;

    settings.vim = {
      viAlias = true;
      vimAlias = true;

      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
      };

      statusline.lualine.enable = true;
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;
      treesitter.enable = true;

      lsp.enable = true;

      languages = {
        nix.enable = true;
        php.enable = true;
        
        # 🔑 Ganti 'ts' jadi 'tsx'
        tsx.enable = true;
        
        # Opsional untuk web dev:
        html.enable = true;
        css.enable = true;
      };
    };
  };
}