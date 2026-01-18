{
  # define autocmd group
  autoGroups = {
    numbertoggle.clear = true;
  };

  autoCmd = [
    {
      desc = "Set 4 space indentation";
      event = "FileType";
      pattern = [
        "cpp"
        "java"
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
      "",
      "alpha",
      "fugitive",
      "help",
      "lazy",
      "NeogitCommitView",
      "NeogitConsole",
      "NeogitStatus",
      "NvimTree",
      "TelescopePrompt",
      "toggleterm",
      "Trouble",
    }

    local ft_guard = function(callback)
      if not vim.tbl_contains(ignore_ft, vim.bo.filetype) then
        callback()
      end
    end
  '';
}
