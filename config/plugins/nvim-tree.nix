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
      select_prompts = true;
      renderer = {
        group_empty = true;
        indent_markers = {
          enable = true;
        };
        highlight_git = "name";
        highlight_modified = "name";
      };
      view = {
        preserve_window_proportions = true;
        width.__raw = "function() return vim.g.nvim_tree_width or 30 end";
      };
      update_focused_file = {
        enable = true;
      };
      modified = {
        enable = true;
      };
      diagnostics = {
        enable = true;
        show_on_dirs = true;
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
