{ utils, ... }:
let
  ignoredUiFiletypes = import ./shared/ignored-ui-filetypes.nix;
in
{
  # define autocmd group
  autoGroups = {
    numbertoggle.clear = true;
    UserLspFloatStyle.clear = true;
    checktime.clear = true;
    LspFixOnSave.clear = true;
    UserLspConfig.clear = true;
  };

  autoCmd = [
    {
      desc = "Reload file if changed on disk";
      event = [
        "FocusGained"
        "BufEnter"
        "CursorHold"
        "CursorHoldI"
      ];
      group = "checktime";
      command = "if mode() != 'c' | checktime | endif";
    }
    {
      desc = "Style LSP floating windows (hover, signature help)";
      event = "FileType";
      pattern = "markdown";
      group = "UserLspFloatStyle";
      callback = {
        __raw = ''
          function(ev)
            local win = vim.api.nvim_get_current_win()
            if vim.api.nvim_win_get_config(win).relative == "" then
              return
            end
            vim.wo[win].winbar = ""
            vim.wo[win].relativenumber = false
            vim.wo[win].scrolloff = 0
            vim.wo[win].conceallevel = 0
            vim.wo[win].concealcursor = ""
            vim.wo[win].number = vim.api.nvim_buf_line_count(ev.buf) > 10

            -- skip past leading blank lines so hover doesn't open on whitespace
            local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
            local first = 1
            while first <= #lines and lines[first]:match("^%s*$") do
              first = first + 1
            end
            if first > 1 and first <= #lines then
              vim.api.nvim_win_set_cursor(win, { first, 0 })
            end
          end
        '';
      };
    }
    {
      desc = "Apply LSP source fixes on save";
      event = "LspAttach";
      group = "LspFixOnSave";
      callback = {
        __raw = ''
          function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local kinds = client and lsp_fix_kinds[client.name]
            if not kinds then
              return
            end

            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = ev.buf,
              group = "LspFixOnSave",
              callback = function()
                lsp_fix_on_save(client, ev.buf, kinds)
              end,
            })
          end
        '';
      };
    }
    {
      desc = "Enable inlay hints on LSP attach";
      event = "LspAttach";
      group = "UserLspConfig";
      callback = {
        __raw = ''
          function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client
              and client.server_capabilities.inlayHintProvider
              and is_file_backed_buffer(ev.buf)
            then
              vim.lsp.inlay_hint.enable(vim.g.inlay_hints_enabled, { bufnr = ev.buf })
            end
          end
        '';
      };
    }
    {
      desc = "Enable spell checking and word wrap for prose, tex, gitcommit";
      event = "FileType";
      pattern = [
        "text"
        "tex"
        "markdown"
        "mdx"
        "markdown.mdx"
        "gitcommit"
      ];
      command = "setlocal spell spelllang=en_us wrap linebreak breakindent";
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

            -- skip when launched directly into a special buffer
            if
              data.file ~= ""
              and vim.fn.isdirectory(data.file) ~= 1
              and vim.bo[data.buf].buftype ~= ""
            then
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
      desc = "Prevent nvim-tree window from scrolling horizontally";
      event = "FileType";
      pattern = "NvimTree";
      command = "setlocal sidescrolloff=0";
    }
    {
      desc = "Remember nvim-tree width when manually resized";
      event = "WinResized";
      pattern = "*";
      callback = {
        __raw = ''
          function()
            -- only remember width while the tree is a sidebar next to other
            -- windows; skip when it is the sole window (would save full width)
            local wins = vim.tbl_filter(function(w)
              return vim.api.nvim_win_get_config(w).relative == ""
            end, vim.api.nvim_tabpage_list_wins(0))
            if #wins <= 1 then
              return
            end

            local win = vim.api.nvim_get_current_win()
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "NvimTree" then
              vim.g.nvim_tree_width = vim.api.nvim_win_get_width(win)
            end
          end
        '';
      };
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
      desc = "Disable rnu when leaving active window";
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
      desc = "Enable rnu when entering active window";
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
      desc = "Toggle rnu around cmdline";
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

  # helper logic for numbertoggle and lsp fix-on-save
  extraConfigLua = ''
    vim.g.inlay_hints_enabled = true

    is_file_backed_buffer = function(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == "" or vim.bo[bufnr].buftype ~= "" then
        return false
      end

      local uri = vim.uri_from_bufnr(bufnr)
      return uri ~= nil and vim.startswith(uri, "file://")
    end

    -- source action kinds to apply on save, per server
    lsp_fix_kinds = {
      eslint = { "source.fixAll.eslint" },
      ts_ls = {
        "source.addMissingImports.ts",
        "source.organizeImports.ts",
        "source.fixAll.ts",
      },
      -- conform already runs ruff_format and ruff_organize_imports
      ruff = { "source.fixAll.ruff" },
    }

    -- applied one kind at a time so they run in the order listed above
    lsp_fix_on_save = function(client, bufnr, kinds)
      for _, kind in ipairs(kinds) do
        local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
        params.context = { only = { kind }, diagnostics = {} }

        local res = client:request_sync("textDocument/codeAction", params, 3000, bufnr)
        for _, action in pairs(res and res.result or {}) do
          -- servers may return an unresolved action carrying only `data`
          if not action.edit and action.data then
            local resolved = client:request_sync("codeAction/resolve", action, 3000, bufnr)
            action = resolved and resolved.result or action
          end
          if action.edit then
            vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
          end
        end
      end
    end

    local ignore_ft = { ${utils.luaList ignoredUiFiletypes} }

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
