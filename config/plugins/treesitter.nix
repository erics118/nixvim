{
  config,
  pkgs,
  utils,
  ...
}:

{
  assertions = [
    (utils.requireDependencies config "treesitter-context" [ "treesitter" ])
    (utils.requireDependencies config "ts-autotag" [ "treesitter" ])
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

  # Auto-close/rename HTML tags
  plugins.ts-autotag = {
    enable = true;
  };

  # Rainbow brackets/delimiters
  plugins.rainbow-delimiters = {
    enable = true;
  };

  # Folding via treesitter. Files open fully unfolded; use zc/zo/za to manage.
  opts = {
    foldmethod = "expr";
    foldexpr = "v:lua.vim.treesitter.foldexpr()";
    foldenable = true;
    foldlevel = 99;
    foldlevelstart = 99;
  };
}
