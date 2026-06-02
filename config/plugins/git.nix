{
  config,
  utils,
  ...
}:
let
  inherit (utils) mkMap;
in
{
  assertions = [
    (utils.requireDependencies config "neogit" [
      "diffview"
    ])
    (utils.requireDependencies config "gitsigns" [
      "which-key"
    ])
  ];

  # Gitsigns keymaps that work via :Gitsigns commands — fine globally;
  # outside a git buffer they no-op with a small error. The [c, ]c, and
  # ih textobject mappings stay in on_attach because they need lua
  # callbacks and buffer scoping.
  keymaps = [
    (mkMap [ "n" "v" ] "<leader>hs" "<cmd>Gitsigns stage_hunk<CR>" "Stage hunk")
    (mkMap [ "n" "v" ] "<leader>hr" "<cmd>Gitsigns reset_hunk<CR>" "Reset hunk")
    (mkMap "n" "<leader>hS" "<cmd>Gitsigns stage_buffer<CR>" "Stage buffer")
    (mkMap "n" "<leader>hu" "<cmd>Gitsigns undo_stage_hunk<CR>" "Undo stage hunk")
    (mkMap "n" "<leader>hR" "<cmd>Gitsigns reset_buffer<CR>" "Reset buffer")
    (mkMap "n" "<leader>hp" "<cmd>Gitsigns preview_hunk<CR>" "Preview hunk")
    (mkMap "n" "<leader>hb" {
      __raw = "function() require('gitsigns').blame_line({ full = true }) end";
    } "Blame line")
    (mkMap "n" "<leader>hd" "<cmd>Gitsigns diffthis<CR>" "Diff current buffer")
    (mkMap "n" "<leader>hD" "<cmd>Gitsigns diffthis ~<CR>" "Diff against last commit")
    (mkMap "n" "<leader>tb" "<cmd>Gitsigns toggle_current_line_blame<CR>" "Toggle blame lines")
    (mkMap "n" "<leader>td" "<cmd>Gitsigns toggle_deleted<CR>" "Toggle deleted lines")
  ];

  # Fugitive - git commands
  plugins.fugitive = {
    enable = true;
    lazyLoad.settings.cmd = [
      "Git"
      "G"
      "Gdiffsplit"
      "Gvdiffsplit"
      "Gvdiff"
      "Gwrite"
      "Gread"
      "Gclog"
      "Ggrep"
      "GMove"
      "GDelete"
      "GBrowse"
      "GRemove"
      "GRename"
    ];
  };

  # Neogit - magit-like git interface
  plugins.neogit = {
    enable = true;
    lazyLoad.settings.cmd = "Neogit";
    settings = {
      integrations = {
        diffview = true;
      };
    };
  };

  # Diffview for neogit
  plugins.diffview = {
    enable = true;
    lazyLoad.settings.cmd = [
      "DiffviewOpen"
      "DiffviewClose"
      "DiffviewToggleFiles"
      "DiffviewFocusFiles"
      "DiffviewFileHistory"
      "DiffviewRefresh"
    ];
  };

  # Gitsigns - git decorations
  plugins.gitsigns = {
    enable = true;
    settings = {
      current_line_blame = true;
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary> | <abbrev_sha>";
      on_attach = {
        __raw = ''
          function(bufnr)
            local gs = require("gitsigns")
            local wk = require("which-key")

            wk.add({
              -- expr mappings: fall back to vim's diff motion when in a diff,
              -- otherwise jump between hunks
              { "[c", function()
                  if vim.wo.diff then return "[c" end
                  vim.schedule(function() gs.prev_hunk() end)
                  return "<Ignore>"
                end,
                desc = "Go to previous hunk", expr = true, mode = "n", buffer = bufnr,
              },
              { "]c", function()
                  if vim.wo.diff then return "]c" end
                  vim.schedule(function() gs.next_hunk() end)
                  return "<Ignore>"
                end,
                desc = "Go to next hunk", expr = true, mode = "n", buffer = bufnr,
              },

              -- textobject: select inside hunk
              { "ih", ":<C-U>Gitsigns select_hunk<CR>",
                desc = "Select inside Hunk", mode = { "o", "x" }, buffer = bufnr,
              },
            })
          end
        '';
      };
    };
  };
}
