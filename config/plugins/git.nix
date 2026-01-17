{
  config,
  helpers,
  ...
}:
{
  assertions = [
    (helpers.requireDependencies config "neogit" [
      "diffview"
    ])
    (helpers.requireDependencies config "gitsigns" [
      "which-key"
    ])
  ];

  # Fugitive - git commands
  plugins.fugitive.enable = true;

  # Neogit - magit-like git interface
  plugins.neogit = {
    enable = true;
    settings = {
      integrations = {
        diffview = true;
      };
    };
  };

  # Diffview for neogit
  plugins.diffview.enable = true;

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
              { "<leader>h",  group = "Gitsigns" },
              { "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>",  desc = "Stage Hunk",      mode = { "n", "v" } },
              { "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>",  desc = "Reset Hunk",      mode = { "n", "v" } },
              { "<leader>hS", gs.stage_buffer,                 desc = "Stage Buffer",    mode = "n" },
              { "<leader>hu", gs.undo_stage_hunk,              desc = "Undo Stage Hunk", mode = "n" },
              { "<leader>hR", gs.reset_buffer,                 desc = "Reset Buffer",    mode = "n" },
              { "<leader>hp", gs.preview_hunk,                 desc = "Preview Hunk",    mode = "n" },
              { "<leader>hb", function() gs.blame_line({ full = true }) end, desc = "Blame line", mode = "n" },
              { "<leader>hd", gs.diffthis,                     desc = "Diff current buffer", mode = "n" },
              { "<leader>hD", function() gs.diffthis("~") end, desc = "Diff against last commit", mode = "n" },
              
              { "<leader>t",  group = "Toggle settings" },
              { "<leader>tb", gs.toggle_current_line_blame,    desc = "Toggle blame lines",   mode = "n" },
              { "<leader>td", gs.toggle_deleted,               desc = "Toggle deleted lines", mode = "n" },
              
              { "[c", function()
                  if vim.wo.diff then
                    return "[c"
                  end
                  vim.schedule(function()
                    gs.prev_hunk()
                  end)
                  return "<Ignore>"
                end,
                desc = "Go to previous hunk",
                expr = true,
                mode = "n"
              },
              { "]c", function()
                  if vim.wo.diff then
                    return "]c"
                  end
                  vim.schedule(function()
                    gs.next_hunk()
                  end)
                  return "<Ignore>"
                end,
                desc = "Go to next hunk",
                expr = true,
                mode = "n"
              },
              
              { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Select inside Hunk", mode = { "o", "x" } },
            })
          end
        '';
      };
    };
  };
}
