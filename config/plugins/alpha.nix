{
  config,
  pkgs,
  helpers,
  ...
}:
let
  name = "alpha";
  mkButton = shortcut: text: command: {
    type = "button";
    val = text;
    opts = {
      shortcut = shortcut;
      width = 50; # width of longest button text
      align_shortcut = "right";
      hl_shortcut = "Keyword";
      position = "center";
      keymap = [
        "n"
        shortcut
        "${command}"
        {
          noremap = true;
          silent = true;
          nowait = true;
        }
      ];
    };
  };
in
{
  assertions = [
    (helpers.requireDependencies config name [
      "web-devicons"
      "telescope"
    ])
  ];

  plugins.${name} = {
    enable = true;
    settings = {
      layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = [
            "  ,-.       _,---._ __  / \\  "
            " /  )    .-'       `./ /   \\ "
            "(  (   ,'            `/    /|"
            " \\  `-\"             \\'\\   / |"
            "  `.              ,  \\ \\ /  |"
            "   /`.          ,'-`----Y   |"
            "  (            ;        |   '"
            "  |  ,-.    ,-'         |  / "
            "  |  | (   |            | /  "
            "  )  |  \\  `.___________|/   "
            "  `--'   `--'                "
          ];
          opts = {
            hl = "Type";
            position = "center";
          };
        }
        {
          type = "padding";
          val = 2;
        }
        # TODO: most recently used files section, numbers 1-9

        # Buttons Section
        {
          type = "group";
          val = [
            (mkButton "n" "  New file" ":ene | startinsert<cr>")
            {
              type = "padding";
              val = 1;
            }
            (mkButton "SPC fd" "  Find file" ":Telescope find_files<cr>")
            {
              type = "padding";
              val = 1;
            }
            (mkButton "SPC fg" "  Live grep" ":Telescope live_grep<cr>")
            {
              type = "padding";
              val = 1;
            }
            (mkButton "SPC fp" "  Projects" ":Telescope project<cr>")
            {
              type = "padding";
              val = 1;
            }
            (mkButton "q" "  Quit" ":qa<cr>")
          ];
        }
        {
          type = "padding";
          val = 1;
        }
        # Footer Section
        {
          type = "text";
          val = "neovim v${pkgs.neovim.version}";
          opts = {
            hl = "Constant";
            position = "center";
          };
        }
      ];
      opts = {
        noautocmd = true;
      };
    };
  };
}
