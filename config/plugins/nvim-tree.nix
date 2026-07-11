{ config, utils, ... }:
let
  name = "nvim-tree";
in
{
  assertions = [ (utils.requireDependencies config name [ "web-devicons" ]) ];

  plugins.${name} = {
    enable = true;
    settings = {
      hijack_cursor = true;
      renderer = {
        indent_markers = {
          enable = true;
        };
        highlight_git = "name";
      };
      view = {
        preserve_window_proportions = true;
        width.__raw = "function() return vim.g.nvim_tree_width or 30 end";
      };
      update_focused_file = {
        enable = true;
      };
      diagnostics = {
        enable = true;
      };
      actions = {
        file_popup = {
          open_win_config = {
            border = "rounded";
          };
        };
      };
      filters = {
        custom = [ "^.git$" ];
      };
    };
  };
}
