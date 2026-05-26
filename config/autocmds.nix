let
  ignoredUiFiletypes = import ./shared/ignored-ui-filetypes.nix;
in
{
  # define autocmd group
  autoGroups = {
    numbertoggle.clear = true;
  };

  autoCmd = [
    {
      desc = "Treat SSH config.local as sshconfig";
      event = [
        "BufNewFile"
        "BufRead"
      ];
      pattern = "*/.ssh/config.local";
      command = "setfiletype sshconfig";
    }
    {
      desc = "Enable spell checking for prose, tex, gitcommit";
      event = "FileType";
      pattern = [
        "text"
        "tex"
        "markdown"
        "mdx"
        "markdown.mdx"
        "gitcommit"
      ];
      command = "setlocal spell spelllang=en_us";
    }
    {
      desc = "Enable word wrap for prose and LaTeX";
      event = "FileType";
      pattern = [
        "text"
        "tex"
        "markdown"
        "mdx"
        "markdown.mdx"
      ];
      command = "setlocal wrap linebreak breakindent";
    }
    {
      desc = "Open nvim-tree on startup";
      event = "VimEnter";
      once = true;
      callback = {
        __raw = ''
          function(data)
            if vim.o.diff then
              return
            end

            if vim.fn.argc(-1) == 0 then
              vim.cmd("NvimTreeOpen")
              return
            end

            if vim.fn.isdirectory(data.file) == 1 then
              vim.cmd("NvimTreeOpen")
              return
            end

            if vim.bo[data.buf].buftype ~= "" then
              return
            end

            vim.cmd("NvimTreeOpen")
            vim.cmd("wincmd p")
          end
        '';
      };
    }
    {
      desc = "Set 4 space indentation";
      event = "FileType";
      pattern = [
        "c"
        "cpp"
        "java"
        "python"
        "rust"
      ];
      command = "setlocal shiftwidth=4 tabstop=4 softtabstop=4";
    }
    {
      desc = "Automatically resize windows when the host window size changes.";
      event = "VimResized";
      pattern = "*";
      command = "wincmd =";
    }
    {
      desc = "Highlight yanked text";
      event = "TextYankPost";
      pattern = "*";
      callback = {
        __raw = "function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end";
      };
    }
    {
      desc = "Notify when recording macro";
      event = [
        "RecordingEnter"
        "RecordingLeave"
      ];
      callback = {
        __raw = ''
          function(data)
            local msg = data.event == "RecordingEnter" and "Recording macro..."
              or "Macro recorded"
            vim.notify(msg, vim.log.levels.INFO, { title = "Macro" })
          end
        '';
      };
    }

    {
      desc = "Disable line numbers in floating windows";
      event = "WinEnter";
      callback = {
        __raw = ''
          function()
            if vim.api.nvim_win_get_config(0).relative ~= "" then
              local show_number = vim.bo.buftype == "nofile"
                and vim.bo.filetype == "markdown"
                and vim.api.nvim_buf_line_count(0) > 10
              vim.wo.number = show_number
              vim.wo.relativenumber = false
              vim.wo.scrolloff = 0
              if vim.bo.buftype == "nofile" and vim.bo.filetype == "markdown" then
                vim.wo.conceallevel = 0
                vim.wo.concealcursor = ""
              end
            end
          end
        '';
      };
    }

    # smarter relative numbers
    {
      desc = "Smarter relative numbers";
      event = [
        "InsertEnter"
        "BufLeave"
        "WinLeave"
        "FocusLost"
      ];
      group = "numbertoggle";
      callback = {
        __raw = "function() ft_guard(function() vim.opt_local.rnu = false end) end";
      };
    }
    {
      desc = "Smarter relative numbers";
      event = [
        "InsertLeave"
        "BufEnter"
        "WinEnter"
        "FocusGained"
      ];
      group = "numbertoggle";
      callback = {
        __raw = "function() ft_guard(function() vim.opt_local.rnu = true end) end";
      };
    }
    {
      desc = "Smarter relative numbers";
      event = [
        "CmdlineEnter"
        "CmdlineLeave"
      ];
      group = "numbertoggle";
      callback = {
        __raw = ''
          function(data)
            ft_guard(function()
              vim.opt.rnu = data.event == "CmdlineLeave"
              vim.cmd("redraw")
            end)
          end
        '';
      };
    }
  ];

  # helper logic for numbertoggle
  extraConfigLua = ''
    local ignore_ft = {
      ${builtins.concatStringsSep ",\n      " (builtins.map builtins.toJSON ignoredUiFiletypes)}
    }

    ft_guard = function(callback)
      if vim.api.nvim_win_get_config(0).relative ~= "" then
        return
      end
      if not vim.tbl_contains(ignore_ft, vim.bo.filetype) then
        callback()
      end
    end
  '';
}
