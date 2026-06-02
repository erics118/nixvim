{
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      # pin flavour explicitly; no runtime theme switching
      flavour = "mocha";
      transparent_background = true;
      styles = {
        comments = [ "italic" ];
      };
      term_colors = true;
      lsp_styles = {
        virtual_text = {
          errors = [ "italic" ];
          hints = [ "italic" ];
          warnings = [ "italic" ];
          information = [ "italic" ];
        };
        underlines = {
          errors = [ "undercurl" ];
          hints = [ "undercurl" ];
          warnings = [ "undercurl" ];
          information = [ "undercurl" ];
        };
      };
      integrations = {
        treesitter_context = true;
        cmp = true;
        lsp_trouble = true;
        nvimtree = true;
        which_key = true;
        indent_blankline = {
          enabled = true;
          colored_indent_levels = true;
        };
        lualine = { };
        gitsigns = true;
        neogit = true;
        notify = true;
      };
      highlight_overrides = {
        all = {
          __raw = ''
            function(colors)
              return {
                -- floats
                NormalFloat = { bg = colors.surface0 },
                FloatBorder = { fg = colors.overlay0, bg = colors.surface0 },
                NvimTreeWinSeparator = { link = "FloatBorder" },
                WhichKeyBorder = { link = "FloatBorder" },
                -- telescope
                TelescopeBorder = { link = "FloatBorder" },
                TelescopeTitle = { fg = colors.text },
                TelescopeSelection = { link = "Selection" },
                TelescopeSelectionCaret = { link = "Selection" },
                -- pmenu
                PmenuSel = { link = "Selection" },
                -- bufferline
                BufferLineTabSeparator = { link = "FloatBorder" },
                BufferLineSeparator = { link = "FloatBorder" },
                BufferLineOffsetSeparator = { link = "FloatBorder" },
                --
                FidgetTitle = { fg = colors.subtext1 },
                FidgetTask = { fg = colors.subtext0 },

                NotifyBackground = { bg = colors.base },
                NotifyINFOBorder = { link = "NotifyINFOTitle" },
                NotifyINFOIcon = { link = "NotifyINFOTitle" },
                NotifyINFOTitle = { fg = colors.pink },
              }
            end
          '';
        };
      };
    };
  };
  colorscheme = "catppuccin-mocha";
}
