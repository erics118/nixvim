{ utils, ... }:
let
  inherit (utils) mkMap;

  # Normal-mode keymap wrapping a lua expression as a function callback
  lspMap =
    key: action: desc:
    mkMap "n" key { __raw = "function() ${action} end"; } desc;

  # version tied to toolchain, binary comes from PATH/devshell
  projectServer = {
    enable = true;
    package = null;
  };
  # stable version, nixvim installs the binary
  ambientServer = {
    enable = true;
  };
in
{
  plugins.lsp.enable = true;

  # SchemaStore for JSON/YAML schemas
  plugins.schemastore = {
    enable = true;
    json.enable = true;
    yaml.enable = true;
  };

  # LSP servers
  plugins.lsp.servers = {
    # Web development
    html = projectServer;
    cssls = projectServer;
    ts_ls = projectServer;
    tailwindcss = projectServer // {
      # Tailwind's upstream filetype list is very broad
      # Only activate it when the nearest package.json declares Tailwind
      extraOptions.root_dir.__raw = ''
        function(bufnr, on_dir)
          local function has_tailwind(deps)
            if type(deps) ~= "table" then
              return false
            end

            return deps.tailwindcss ~= nil or vim.iter(vim.tbl_keys(deps)):any(function(name)
              return vim.startswith(name, "@tailwindcss/")
            end)
          end

          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname == "" then
            return
          end

          local path = vim.fs.dirname(bufname)
          if path == nil then
            return
          end

          local package_json = vim.fs.find("package.json", { upward = true, path = path })[1]
          if package_json == nil then
            return
          end

          local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(package_json), "\n"))
          if not ok or type(decoded) ~= "table" then
            return
          end

          if has_tailwind(decoded.dependencies) or has_tailwind(decoded.devDependencies) then
            on_dir(vim.fs.dirname(package_json))
          end
        end
      '';
    };
    astro = projectServer;
    nextls = projectServer;

    # TypeScript/JavaScript linting
    eslint = projectServer // {
      settings.workingDirectories.mode = "auto";
    };

    # Data formats
    jsonls = ambientServer;
    texlab = projectServer // {
      settings.texlab = {
        build = {
          executable = "latexmk";
          args = [
            "-pdf"
            "-interaction=nonstopmode"
            "-synctex=1"
            "%f"
          ];
          onSave = true;
          forwardSearchAfter = false;
        };
        forwardSearch = {
          executable = "sioyek";
          args = [
            "--reuse-window"
            "--execute-command"
            "toggle_synctex"
            "--inverse-search"
            "nvim --headless -c \"VimtexInverseSearch %2 '%1'\""
            "--forward-search-file"
            "%f"
            "--forward-search-line"
            "%l"
            "%p"
          ];
        };
        chktex = {
          onEdit = true;
          onOpenAndSave = true;
        };
        diagnosticsDelay = 300;
        formatterLineLength = 100;
        latexFormatter = "none";
      };
    };
    yamlls = ambientServer // {
      settings = {
        yaml = {
          completion = true;
          validate = true;
          suggest.parentSkeletonSelectedFirst = true;
          schemas = {
            "https://json.schemastore.org/github-action" = ".github/action.{yaml,yml}";
            "https://json.schemastore.org/github-workflow" = ".github/workflows/*";
            "https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json" =
              "*lab-ci.{yaml,yml}";
            "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
              "docker-compose.{yml,yaml}";
          };
        };
        redhat.telemetry.enabled = false;
      };
    };

    # DevOps
    dockerls = projectServer;
    taplo = ambientServer;

    # Markdown
    marksman = ambientServer;

    # Shell
    bashls = ambientServer;

    # Spell-check across all buffers
    typos_lsp = ambientServer;

    # Go
    gopls = projectServer;

    # Lua
    lua_ls = projectServer;

    # OCaml
    ocamllsp = projectServer // {
      extraOptions = {
        settings = {
          inlayHints = {
            enable = true;
            hintPatternVariables = true;
            hintLetBindings = true;
            hintFunctionParams = true;
          };
        };
        init_options = {
          codelens.enable = true;
          extendedHover.enable = true;
        };
      };
    };

    # Nix
    nixd = projectServer;

    # Python
    pyright = projectServer; # types
    ruff = projectServer; # lint + code actions

    # Java
    jdtls = projectServer;

    # Zig
    zls = projectServer;

    # Haskell
    hls = projectServer // {
      installGhc = false;
      settings.haskell = {
        formattingProvider = "fourmolu";
      };
    };

    # Elixir (nextls already enabled above for web)

    # C/C++
    cmake = projectServer;

    clangd = projectServer // {
      cmd = [
        "clangd"
        "--inlay-hints=true"
        "--background-index"
        "--clang-tidy"
        "--enable-config"
        "--all-scopes-completion"
        "--completion-style=detailed"
        "-j=8"
        "--header-insertion=iwyu"
        "--header-insertion-decorators"
      ];
    };

    rust_analyzer = projectServer // {
      installCargo = false;
      installRustc = false;
      settings.rust-analyzer = {
        cargo = {
          allFeatures = true;
          loadOutDirsFromCheck = true;
        };
        checkOnSave = true;
        check = {
          command = "clippy";
          extraArgs = [ "--no-deps" ];
        };
        procMacro.enable = true;
        inlayHints = {
          bindingModeHints.enable = true;
          closingBraceHints.enable = true;
          closureReturnTypeHints.enable = "always";
          lifetimeElisionHints.enable = "always";
          parameterHints.enable = true;
          typeHints.enable = true;
        };
      };
    };
  };

  # Completion
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      snippet = {
        expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
      };
      mapping.__raw = ''
        cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-j>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            local luasnip = require("luasnip")
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            local luasnip = require("luasnip")
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        })
      '';
      sources = [
        { name = "nvim_lsp"; }
        { name = "vimtex"; }
        { name = "luasnip"; }
        { name = "buffer"; }
        { name = "path"; }
      ];
    };
    cmdline = {
      "/" = {
        mapping.__raw = "cmp.mapping.preset.cmdline()";
        sources = [ { name = "buffer"; } ];
      };
      ":" = {
        mapping.__raw = "cmp.mapping.preset.cmdline()";
        sources = [
          { name = "path"; }
          { name = "cmdline"; }
        ];
      };
    };
  };

  # Snippets
  plugins.luasnip = {
    enable = true;
    fromVscode = [ { } ];
  };

  # LSP icons in completion
  plugins.lspkind = {
    enable = true;
    cmp.enable = true;
    settings = {
      mode = "symbol_text";
      maxwidth = 50;
      ellipsis_char = "...";
    };
  };

  # LSP Keymaps
  keymaps = [
    (lspMap "gD" "vim.lsp.buf.declaration()" "Go to declaration")
    (lspMap "gd" "vim.lsp.buf.definition()" "Go to definition")
    (lspMap "K" "vim.lsp.buf.hover({ max_width = 80, max_height = 20 })" "Hover documentation")
    (lspMap "gi" "vim.lsp.buf.implementation()" "Go to implementation")
    (lspMap "<leader>k" "vim.lsp.buf.signature_help()" "Signature help")
    (lspMap "<leader>D" "vim.lsp.buf.type_definition()" "Type definition")
    (lspMap "<leader>rn" "vim.lsp.buf.rename()" "Rename symbol")
    (lspMap "gr" "vim.lsp.buf.references()" "Go to references")
    (lspMap "<leader>lr" "vim.cmd('LspRestart')" "Restart LSP")
    (lspMap "]d" "vim.diagnostic.goto_next()" "Next diagnostic")
    (lspMap "[d" "vim.diagnostic.goto_prev()" "Previous diagnostic")
    (lspMap "<leader>e" "vim.diagnostic.open_float()" "Open diagnostic float")
    (lspMap "<leader>ti"
      "local bufnr = 0; local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }); vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr }); vim.notify('Inlay hints: ' .. (enabled and 'OFF' or 'ON'), vim.log.levels.INFO)"
      "Toggle inlay hints"
    )
    (lspMap "<leader>wa" "vim.lsp.buf.add_workspace_folder()" "Add workspace folder")
    (lspMap "<leader>wr" "vim.lsp.buf.remove_workspace_folder()" "Remove workspace folder")
    (mkMap [ "n" "v" ] "<leader>ca" {
      __raw = "function() vim.lsp.buf.code_action() end";
    } "Code action")
    (mkMap "n" "<leader>xx" "<cmd>Trouble diagnostics toggle<CR>" "Trouble diagnostics")
    (mkMap "n" "<leader>xd" "<cmd>Trouble lsp_definitions<CR>" "Trouble LSP definitions")
    (mkMap "n" "<leader>xq" "<cmd>Trouble quickfix<CR>" "Trouble quickfix")
    (mkMap "n" "<leader>xl" "<cmd>Trouble loclist<CR>" "Trouble location list")
    (mkMap "n" "<leader>lv" "<cmd>TexlabForward<CR>" "LaTeX forward search")
  ];

  plugins.trouble = {
    enable = true;
    lazyLoad.settings.cmd = "Trouble";
    settings.padding = false;
  };

  # Attach inlay hints and codelens on LSP attach
  extraConfigLua = ''
    local function is_file_backed_buffer(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == "" or vim.bo[bufnr].buftype ~= "" then
        return false
      end

      local uri = vim.uri_from_bufnr(bufnr)
      return uri ~= nil and vim.startswith(uri, "file://")
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client
          and client.server_capabilities.inlayHintProvider
          and is_file_backed_buffer(ev.buf)
        then
          vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end
      end,
    })
  '';

  filetype = {
    extension = {
      opam = "opam";
      jq = "jq";
      ixx = "cpp";
      cppm = "cpp";
      cxxm = "cpp";
      "c++m" = "cpp";
      mxx = "cpp";
    };
    pattern = {
      ".*/%.ssh/config%.local" = "sshconfig";
    };
  };
}
