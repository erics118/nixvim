{ lib, ... }:
let
  # Kubernetes resource types for YAML schema
  k8sResources = [
    "clusterrole"
    "clusterrolebinding"
    "configmap"
    "cronjob"
    "daemonset"
    "deployment"
    "hpa"
    "ingress"
    "job"
    "namespace"
    "pvc"
    "rbac"
    "replicaset"
    "role"
    "rolebinding"
    "secret"
    "service"
    "serviceaccount"
    "statefulset"
  ];
  k8sPatterns =
    lib.concatMap (r: [
      "${r}.yaml"
      "${r}.yml"
    ]) k8sResources
    ++ [
      "*-deployment.yaml"
      "*-deployment.yml"
      "*-service.yaml"
      "*-service.yml"
    ];

  # Helper for LSP keymaps (lua action)
  lspMap = key: action: desc: {
    mode = "n";
    inherit key;
    action = "<cmd>lua ${action}<CR>";
    options = {
      noremap = true;
      silent = true;
      inherit desc;
    };
  };

  # Helper for command keymaps (non-lua)
  cmdMap = key: action: desc: {
    mode = "n";
    inherit key;
    action = "<cmd>${action}<CR>";
    options = {
      noremap = true;
      silent = true;
      inherit desc;
    };
  };

  projectServer = {
    enable = true;
    package = null;
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
    tailwindcss = projectServer;
    astro = projectServer;
    nextls = projectServer;

    # TypeScript/JavaScript linting
    eslint = {
      enable = true;
      package = null;
      settings.workingDirectories.mode = "auto";
    };

    # Data formats
    jsonls = projectServer;
    texlab = {
      enable = true;
      package = null;
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
        chktex = {
          onEdit = true;
          onOpenAndSave = true;
        };
        diagnosticsDelay = 300;
        formatterLineLength = 100;
        latexFormatter = "latexindent";
      };
    };
    yamlls = {
      enable = true;
      package = null;
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
            "https://json.schemastore.org/helmfile" = "helmfile.{yaml,yml}";
            "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json" =
              "docker-compose.{yml,yaml}";
            kubernetes = k8sPatterns;
          };
        };
        redhat.telemetry.enabled = false;
      };
    };

    # DevOps
    dockerls = projectServer;
    taplo = projectServer; # TOML

    # Markdown
    # we install this one so it works globally
    marksman = {
      enable = true;
    };

    # Shell
    bashls = projectServer;

    # Go
    gopls = projectServer;

    # Lua
    lua_ls = projectServer;

    # OCaml - use project's ocamllsp (from opam/devshell) to avoid version mismatch
    ocamllsp = {
      enable = true;
      package = null;
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
    pyright = projectServer;

    # Java
    jdtls = projectServer;

    # C/C++
    cmake = projectServer;

    clangd = {
      enable = true;
      package = null;
      cmd = [
        "clangd"
        "--inlay-hints=true"
        "--clang-tidy"
        "--enable-config"
        "--experimental-modules-support"
      ];
    };

    rust_analyzer = {
      enable = true;
      package = null;
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
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
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
    (lspMap "K" "vim.lsp.buf.hover()" "Hover documentation")
    (lspMap "gi" "vim.lsp.buf.implementation()" "Go to implementation")
    (lspMap "<leader>k" "vim.lsp.buf.signature_help()" "Signature help")
    (lspMap "<leader>D" "vim.lsp.buf.type_definition()" "Type definition")
    (lspMap "<leader>rn" "vim.lsp.buf.rename()" "Rename symbol")
    (lspMap "gr" "vim.lsp.buf.references()" "Go to references")
    (lspMap "<leader>lr" "vim.cmd('LspRestart')" "Restart LSP")
    (lspMap "]d" "vim.diagnostic.goto_next()" "Next diagnostic")
    (lspMap "[d" "vim.diagnostic.goto_prev()" "Previous diagnostic")
    (lspMap "<leader>e" "vim.diagnostic.open_float()" "Open diagnostic float")
    (lspMap "<leader>ih"
      "local bufnr = 0; local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }); vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr }); vim.notify('Inlay hints: ' .. (enabled and 'OFF' or 'ON'), vim.log.levels.INFO)"
      "Toggle inlay hints"
    )
    (lspMap "<leader>wa" "vim.lsp.buf.add_workspace_folder()" "Add workspace folder")
    (lspMap "<leader>wr" "vim.lsp.buf.remove_workspace_folder()" "Remove workspace folder")
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ca";
      action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
      options.desc = "Code action";
    }
    (cmdMap "<leader>xx" "Trouble diagnostics toggle" "Trouble diagnostics")
    (cmdMap "<leader>xd" "Trouble lsp_definitions" "Trouble LSP definitions")
    (cmdMap "<leader>xq" "Trouble quickfix" "Trouble quickfix")
    (cmdMap "<leader>xl" "Trouble loclist" "Trouble location list")
  ];

  plugins.trouble = {
    enable = true;
    lazyLoad.settings.cmd = "Trouble";
    settings.padding = false;
  };

  # Attach inlay hints and codelens on LSP attach
  extraConfigLua = ''
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end
        if client.server_capabilities.codeLensProvider then
          vim.lsp.codelens.refresh({ bufnr = ev.buf })
        end
      end,
    })

    vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
      local merged_config = vim.tbl_extend("force", {
        border = "rounded",
        max_width = 80,
        max_height = 20,
      }, config or {})

      local bufnr, winnr = vim.lsp.handlers.hover(err, result, ctx, merged_config)
      if winnr and vim.api.nvim_win_is_valid(winnr) then
        vim.schedule(function()
          if not vim.api.nvim_win_is_valid(winnr) then
            return
          end

          vim.wo[winnr].winbar = ""
          vim.wo[winnr].relativenumber = false
          vim.wo[winnr].scrolloff = 0
          vim.wo[winnr].conceallevel = 0
          vim.wo[winnr].concealcursor = ""

          if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
            -- show line numbers in buf only if > 10 lines
            vim.wo[winnr].number = vim.api.nvim_buf_line_count(bufnr) > 10
            local hover_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            local first_nonblank = 1
            while first_nonblank <= #hover_lines and hover_lines[first_nonblank]:match("^%s*$") do
              first_nonblank = first_nonblank + 1
            end
            if first_nonblank > 1 and first_nonblank <= #hover_lines then
              vim.api.nvim_win_set_cursor(winnr, { first_nonblank, 0 })
            end
          else
            vim.wo[winnr].number = false
          end
        end)
      end

      return bufnr, winnr
    end

  '';

  filetype.extension = {
    opam = "opam";
    jq = "jq";
    ixx = "cpp";
    cppm = "cpp";
    cxxm = "cpp";
    "c++m" = "cpp";
    mxx = "cpp";
  };
}
