{ config, utils, ... }:
let
  inherit (utils) mkMap;
in
{
  assertions = [ (utils.requireDependencies config "headlines" [ "treesitter" ]) ];

  plugins = {
    direnv.enable = true;
    flash.enable = true;
    todo-comments = {
      enable = true;
      lazyLoad.settings.event = "BufReadPost";
    };
    nvim-surround.enable = true;
    headlines = {
      enable = true;
      lazyLoad.settings.ft = [
        "markdown"
        "norg"
        "rmd"
        "org"
      ];
    };
  };

  # Keymaps for flash
  keymaps = [
    (mkMap [ "n" "x" "o" ] "s" { __raw = "function() require('flash').jump() end"; } "Flash")
    (mkMap [ "n" "o" "x" ] "S" {
      __raw = "function() require('flash').treesitter() end";
    } "Flash Treesitter")
    (mkMap "o" "r" { __raw = "function() require('flash').remote() end"; } "Remote Flash")
    (mkMap [ "o" "x" ] "R" {
      __raw = "function() require('flash').treesitter_search() end";
    } "Treesitter Search")
    (mkMap "c" "<C-f>" { __raw = "function() require('flash').toggle() end"; } "Toggle Flash Search")
  ];
}
