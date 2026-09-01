{ pkgs, ... }:

{
  programs.nvf.enableManpages = true;
  programs.nvf = {
  enable = true;

  settings.vim = {
    lsp.enable = true;

    globals.mapleader = " ";

    keymaps = [
      # Filetree (Space + e)
      { key = "<leader>e"; action = ":Neotree toggle<CR>"; mode = "n"; desc = "Toggle Filetree"; }

      # Search teks di project (Space + f kecil)
      #{ key = "<leader>f"; action = ":Telescope live_grep<CR>"; mode = "n"; desc = "Search Text"; }

      # Search file (Space + F besar / Space + Shift + f)
      { key = "<leader>f"; action = ":Telescope find_files<CR>"; mode = "n"; desc = "Search Files"; }

      # Lihat buffer (Space + b)
      { key = "<leader>b"; action = ":Telescope buffers<CR>"; mode = "n"; desc = "View Buffers"; }

      { key = "<leader>x"; action = ":Telescope diagnostics<CR>"; mode = "n"; desc = "Show All Workspace Diagnostics"; }
    ];

     filetype = {
      extension = {
        "blade.php" = "php";    
        };                           
     };

    languages = {
      enableTreesitter = true;
      enableFormat = true;

      nix.enable = true;
      lua.enable = true;
      python.enable = true;
      go.enable = true;
      typescript.enable = true;

      rust.enable = true;
    };

    # Atur indentasi dasar Neovim
    options = {
     shiftwidth = 2;
     tabstop = 2;
     expandtab = true;
     smartindent = false; # Matikan smartindent bawaan yang suka ngawur di Nix
     ignorecase = true;
     smartcase = true;
    };

    autocomplete.blink-cmp.enable = true;
    telescope.enable = true;
    filetree.neo-tree.enable = true;
    autopairs.nvim-autopairs.enable = true;
    treesitter.indent.enable = true;
    git.gitsigns.enable = true;
    tabline.nvimBufferline.enable = true;

    statusline.lualine.enable = true;

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
    };
  };
};
}
