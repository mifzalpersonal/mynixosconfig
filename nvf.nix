{ pkgs, ... }:

{
  programs.nvf = {
    enable = true;

    settings.vim = {
      viAlias = true;
      vimAlias = true;

      # 1. Tombol Spasi Cheatsheet (which-key)
      binds.whichKey.enable = true;

      # 2. File Selector & Picker (FZF atau Telescope)
      # Pilih salah satu (atau keduanya):
      fzf.cmake-passthrough = false; # FZF Lua Integration
      fzf.enable = true;             # Pakai fzf-lua

      # 3. Buffer Line (Tab Bar / Buffer Selector)
      tabline.nvimBufferline.enable = true;

      # File Tree / File Explorer Sidebar (NvimTree)
      filetree.nvimTree.enable = true;
      
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