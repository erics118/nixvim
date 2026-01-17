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

  # Helper for LSP keymaps
  lspMap = key: action: desc: {
    mode = "n";
    inherit key;
    action = "<cmd>lua ${action}<CR>";
    options.desc = desc;
  };
in
{
  plugins.lsp.enable = true;
  plugins.lsp-format.enable = true;

  # SchemaStore for JSON/YAML schemas
  plugins.schemastore = {
    enable = true;
    json.enable = true;
    yaml.enable = true;
  };

  # LSP servers
  plugins.lsp.servers = {
    # Web development
    html.enable = true;
    cssls.enable = true;
    ts_ls.enable = true;

    # TypeScript/JavaScript linting
    eslint = {
      enable = true;
      settings.workingDirectories.mode = "auto";
    };

    # Data formats
    jsonls.enable = true;
    yamlls = {
      enable = true;
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
    dockerls.enable = true;
    taplo.enable = true; # TOML

    # Shell
    bashls.enable = true;

    # Go
    gopls.enable = true;

    # Lua
    lua_ls.enable = true;

    # OCaml
    ocamllsp.enable = true;

    # Nix
    nixd.enable = true;

    # Python
    pyright.enable = true;

    # Java
    jdtls.enable = true;

    # C/C++
    clangd = {
      enable = true;
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

  # Cmp sources
  plugins.cmp-nvim-lsp.enable = true;
  plugins.cmp-buffer.enable = true;
  plugins.cmp-path.enable = true;
  plugins.cmp-cmdline.enable = true;

  # LSP Keymaps
  keymaps = [
    (lspMap "gD" "vim.lsp.buf.declaration()" "Go to declaration")
    (lspMap "gd" "vim.lsp.buf.definition()" "Go to definition")
    (lspMap "K" "vim.lsp.buf.hover()" "Hover documentation")
    (lspMap "gi" "vim.lsp.buf.implementation()" "Go to implementation")
    (lspMap "<C-k>" "vim.lsp.buf.signature_help()" "Signature help")
    (lspMap "<leader>D" "vim.lsp.buf.type_definition()" "Type definition")
    (lspMap "<leader>rn" "vim.lsp.buf.rename()" "Rename symbol")
    (lspMap "gr" "vim.lsp.buf.references()" "Go to references")
    (lspMap "<leader>lr" "vim.cmd('LspRestart')" "Restart LSP")
    (lspMap "]d" "vim.diagnostic.goto_next()" "Next diagnostic")
    (lspMap "[d" "vim.diagnostic.goto_prev()" "Previous diagnostic")
    (lspMap "<leader>fm" "vim.lsp.buf.format({ async = true })" "Format buffer")
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
  ];

  plugins.trouble = {
    enable = true;
    settings.padding = false;
  };

  # Attach navic on LSP attach
  extraConfigLua = ''
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local ok, navic = pcall(require, "nvim-navic")
        if ok and client.server_capabilities.documentSymbolProvider then navic.attach(client, ev.buf) end
      end,
    })
  '';

  filetype.extension = {
    jq = "jq";
    ixx = "cpp";
    cppm = "cpp";
    cxxm = "cpp";
    "c++m" = "cpp";
    mxx = "cpp";
  };
}
