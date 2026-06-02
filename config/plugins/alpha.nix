{
  config,
  pkgs,
  utils,
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
    (utils.requireDependencies config name [
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

        # recent files, populated from vim.v.oldfiles at startup
        {
          type = "text";
          val = "Recent files";
          opts = {
            hl = "SpecialComment";
            position = "center";
          };
        }
        {
          type = "padding";
          val = 1;
        }
        {
          type = "group";
          val.__raw = ''
            function()
              local buttons = {}
              local max = 9
              for _, file in ipairs(vim.v.oldfiles) do
                if vim.fn.filereadable(file) == 1 then
                  local n = #buttons + 1
                  if n > max then break end
                  local key = tostring(n)
                  local short = vim.fn.fnamemodify(file, ":~:.")
                  if #short > 46 then
                    short = "…" .. string.sub(short, -45)
                  end
                  table.insert(buttons, {
                    type = "button",
                    val = "  " .. short,
                    on_press = function()
                      vim.cmd("edit " .. vim.fn.fnameescape(file))
                    end,
                    opts = {
                      shortcut = key,
                      align_shortcut = "right",
                      hl_shortcut = "Keyword",
                      position = "center",
                      width = 50,
                      keymap = {
                        "n", key,
                        "<cmd>edit " .. vim.fn.fnameescape(file) .. "<cr>",
                        { noremap = true, silent = true, nowait = true },
                      },
                    },
                  })
                end
              end
              return buttons
            end
          '';
        }
        {
          type = "padding";
          val = 2;
        }

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
