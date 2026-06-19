{ config, utils, ... }:
let
  name = "telescope";
  inherit (utils) mkMap;
in
{
  assertions = [ (utils.requireDependencies config name [ "web-devicons" ]) ];

  plugins.${name} = {
    enable = true;
    lazyLoad.settings.cmd = "Telescope";
    settings = {
      defaults = {
        prompt_prefix = " ";
        selection_caret = " ";
        multi_icon = "│";
        borderchars = [
          "─"
          "│"
          "─"
          "│"
          "╭"
          "╮"
          "╯"
          "╰"
        ];
      };
      pickers = {
        find_files = {
          previewer = false;
          prompt_title = false;
          results_title = false;
        };
        live_grep = {
          previewer = true;
        };
      };
    };
    extensions = {
      fzf-native = {
        enable = true;
        settings = {
          fuzzy = true;
          override_generic_sorter = true;
          override_file_sorter = true;
          case_mode = "smart_case";
        };
      };
      file-browser = {
        enable = true;
        settings = {
          grouped = true;
          sorting_strategy = "ascending";
        };
      };
      ui-select.enable = true;
    };
  };

  keymaps = [
    (mkMap "n" "<leader>fb" "<cmd>Telescope file_browser grouped=true<cr>" "File browser")
    (mkMap "n" "<leader>fd" "<cmd>Telescope find_files<cr>" "Find file")
    (mkMap "n" "<leader>fg" "<cmd>Telescope live_grep<cr>" "Live grep")
    (mkMap "n" "<leader>fh" "<cmd>Telescope help_tags<cr>" "Help tags")
    (mkMap "n" "<leader>fn" "<cmd>Telescope notify<cr>" "Show notifications")
    (mkMap "n" "<leader>fr" "<cmd>Telescope oldfiles<cr>" "Recent files")
    (mkMap "n" "<leader>ft" "<cmd>TodoTelescope<cr>" "Search TODOs")
    (mkMap "n" "<leader>fs" {
      __raw = ''
        function()
          require("telescope.builtin").find_files({
            cwd = vim.fn.resolve(vim.fn.stdpath("config")),
          })
        end
      '';
    } "Find in config")
  ];
}
