{
  config,
  utils,
  ...
}:
let
  name = "telescope";
in
{
  assertions = [
    (utils.requireDependencies config name [
      "web-devicons"
    ])
  ];

  plugins.${name} = {
    enable = true;
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
    {
      mode = "n";
      key = "<leader>f";
      action = "";
      options = {
        desc = "+Telescope";
      };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope file_browser grouped=true<cr>";
      options = {
        desc = "File browser";
      };
    }
    {
      mode = "n";
      key = "<leader>fd";
      action = "<cmd>Telescope find_files<cr>";
      options = {
        desc = "Find file";
      };
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<cr>";
      options = {
        desc = "Live grep";
      };
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<cr>";
      options = {
        desc = "Help tags";
      };
    }
    {
      mode = "n";
      key = "<leader>fn";
      action = "<cmd>Telescope notify<cr>";
      options = {
        desc = "Show notifications";
      };
    }
    {
      mode = "n";
      key = "<leader>fs";
      action = {
        __raw = ''
          function()
            require("telescope.builtin").find_files({
              cwd = vim.fn.resolve(vim.fn.stdpath("config")),
            })
          end
        '';
      };
      options = {
        desc = "Find in config";
      };
    }
  ];
}
