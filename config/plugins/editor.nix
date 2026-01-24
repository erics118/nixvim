{ config, utils, ... }:
{
  assertions = [
    (utils.requireDependencies config "headlines" [ "treesitter" ])
  ];

  plugins = {
    flash.enable = true;
    todo-comments.enable = true;
    nvim-surround.enable = true;
    comment.enable = true;
    headlines.enable = true;
  };

  # Keymaps for flash
  keymaps = [
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "s";
      action.__raw = "function() require('flash').jump() end";
      options.desc = "Flash";
    }
    {
      mode = [
        "n"
        "o"
        "x"
      ];
      key = "S";
      action.__raw = "function() require('flash').treesitter() end";
      options.desc = "Flash Treesitter";
    }
    {
      mode = "o";
      key = "r";
      action.__raw = "function() require('flash').remote() end";
      options.desc = "Remote Flash";
    }
    {
      mode = [
        "o"
        "x"
      ];
      key = "R";
      action.__raw = "function() require('flash').treesitter_search() end";
      options.desc = "Treesitter Search";
    }
    {
      mode = "c";
      key = "<C-f>";
      action.__raw = "function() require('flash').toggle() end";
      options.desc = "Toggle Flash Search";
    }
  ];
}
