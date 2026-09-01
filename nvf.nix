{ pkgs, ... }:

{
  
  environment.systemPackages = with pkgs; [
    golangci-lint
    ruff
    luaPackages.luacheck
    eslint
    tree-sitter-grammars.tree-sitter-blade
    phpPackages.php-codesniffer
  ];

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
      { key = "<leader>f"; action = ":Telescope find_files<CR>"; mode = "n"; desc = "Search Files"; }

      # Search file (Space + F besar / Space + Shift + f)
      { key = "<leader>F"; action = ":Telescope live_grep<CR>"; mode = "n"; desc = "Search Text"; }
      
      { key = "<leader>fr"; action = ":Telescope oldfiles<CR>"; mode = "n"; desc = "Recently Used"; }

      # Lihat buffer (Space + b)
      { key = "<leader>b"; action = ":Telescope buffers<CR>"; mode = "n"; desc = "View Buffers"; }

      { key = "<leader>fd"; action = ":Telescope diagnostics<CR>"; mode = "n"; desc = "Show All Workspace Diagnostics"; }
      
      
      { key = "<Tab>"; action = "<cmd>BufferLineCycleNext<CR>"; mode = "n"; desc = "Next Buffer"; }
     
     
      { key = "<S-Tab>"; action = "<cmd>BufferLineCyclePrev<CR>"; mode = "n"; desc = "Previous Buffer"; }

    ];

     filetype = {
      extension = {
        "blade" = "php";    
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
      html.enable = true;
      css.enable = true;
    };

    treesitter = {
     highlight.enable = true;
   
     grammars = with pkgs.tree-sitter-grammars; [
       tree-sitter-blade
     ];
   };  

    lsp.presets.tailwindcss-language-server.enable = true;  

    # dashboard
    dashboard = {
      alpha = {
        theme = "dashboard";
        enable = true;  
      };
    };

    # diagnostics.config = {
    #   virtual_text = true;
    #   signs = true;
    #   underline = true;
    #   update_in_insert = false;  
    # };

    luaConfigRC.diagnostics = ''
     vim.diagnostic.config({
       virtual_text = true,
       signs = true,
       underline = true,
       update_in_insert = false,
     })
    '';

    diagnostics.nvim-lint.enable = true;

    diagnostics.nvim-lint.linters_by_ft = {
      lua = [ "luacheck" ];
      python = [ "ruff" ];
    
      javascript = [ "eslint" ];
      javascriptreact = [ "eslint" ];
      typescript = [ "eslint" ];
      typescriptreact = [ "eslint" ];
    
      go = [ "golangcilint" ];
    
      rust = [ "clippy" ];
    
      php = [ "phpcs" ];
    };  
      

    # Atur indentasi dasar Neovim
    options = {
     shiftwidth = 2;
     tabstop = 2;
     expandtab = true;
     smartindent = false; # Matikan smartindent bawaan yang suka ngawur di Nix
     ignorecase = true;
     smartcase = true;
     wrap = false;
     linebreak = true;
    };


    # fitur tambahan alias plugin
    autocomplete.blink-cmp.enable = true;
    autocomplete.blink-cmp.friendly-snippets.enable = true;
    utility.motion.flash-nvim.enable = true;
    telescope.enable = true;
    filetree.neo-tree.enable = true;
    autopairs.nvim-autopairs.enable = true;
    treesitter.indent.enable = true;
    git.gitsigns.enable = true;
    
    tabline.nvimBufferline = {
      enable = true;
    
      setupOpts = {
        options = {
          mode = "buffers";
          separator_style = "thin";
          always_show_bufferline = true;
    
          tab_size = 8;
          padding = 1;
        };
      };
    };

    extraPlugins = {
      hlchunk = {
        package = pkgs.vimPlugins.hlchunk-nvim;
    
        setup = ''
          require("hlchunk").setup({
            chunk = {
              enable = true;
              use_treesitter = true;
    
              chars = {
                horizontal_line = "─";
                vertical_line = "│";
                left_top = "╭";
                left_bottom = "╰";
                right_arrow = ">";
              };
    
              duration = 200;
              delay = 300;
              error_sign = true;
            };
    
            indent = {
              enable = true;
              use_treesitter = false;
    
              chars = {
                "│";
              };
    
              ahead_lines = 5;
              delay = 100;
            };
    
            line_num = {
              enable = false;
            };
    
            blank = {
              enable = false;
            };
          });
        '';
      };
    };  


    session.persisted.enable = true;
    statusline.lualine.enable = true;
    

    theme = {
      enable = true;
      name = "catppuccin";
      style = "frappe";
    };
  };
};
}
