{
  config,
  pkgs,
  utils,
  ...
}:

{
  assertions = [
    (utils.requireDependencies config "treesitter-context" [
      "treesitter"
    ])
    (utils.requireDependencies config "ts-autotag" [
      "treesitter"
    ])
  ];

  plugins.treesitter = {
    enable = true;
    nixGrammars = true; # Use nix-managed grammars
    settings = {
      highlight = {
        enable = true;
      };
      indent = {
        enable = true;
      };
    };
    # Install all grammars packaged with nixpkgs
    grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
  };

  # Treesitter context - shows function context at top of window
  plugins.treesitter-context = {
    enable = true;
    settings = {
      mode = "topline";
    };
  };

  # Auto-close/rename HTML tags
  plugins.ts-autotag = {
    enable = true;
  };

  # Rainbow brackets/delimiters
  plugins.rainbow-delimiters = {
    enable = true;
  };

  # Folding settings (using treesitter for folding)
  opts = {
    foldmethod = "expr";
    foldexpr = "v:lua.vim.treesitter.foldexpr()";
    foldenable = false;
  };
}
