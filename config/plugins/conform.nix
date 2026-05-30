{
  plugins.conform-nvim = {
    enable = true;
    autoInstall.enable = false;
    settings = {
      notify_on_error = false;
      format_on_save = {
        timeout_ms = 800;
        lsp_format = "fallback";
      };

      formatters_by_ft = {
        "_" = [
          "trim_whitespace"
          "trim_newlines"
        ];
        lua = [ "stylua" ];
        nix = [ "nixfmt" ];
        sh = [ "shfmt" ];
        bash = [ "shfmt" ];
        zsh = [ "shfmt" ];

        javascript = [ "prettier" ];
        javascriptreact = [ "prettier" ];
        typescript = [ "prettier" ];
        typescriptreact = [ "prettier" ];
        astro = [ "prettier" ];
        css = [ "prettier" ];
        scss = [ "prettier" ];
        less = [ "prettier" ];
        html = [ "prettier" ];
        graphql = [ "prettier" ];
        vue = [ "prettier" ];
        svelte = [ "prettier" ];
        json = [ "prettier" ];
        jsonc = [ "prettier" ];
        yaml = [ "prettier" ];
        markdown = [ "prettier" ];

        toml = [ "taplo" ];
        just = [ "just" ];
        cmake = [ "gersemi" ];
        python = [
          "ruff_format"
          "ruff_organize_imports"
        ];
        go = [ "gofmt" ];
        rust = [ "rustfmt" ];
        tex = [ "latexindent" ];
        ocaml = [ "ocamlformat" ];
        c = [ "clang_format" ];
        cpp = [ "clang_format" ];
        zig = [ "zigfmt" ];
        haskell = [ "fourmolu" ];
        elixir = [ "mix" ];
      };
    };
  };

  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>lf";
      action.__raw = "function() require('conform').format({ async = true, lsp_format = 'fallback' }) end";
      options = {
        noremap = true;
        silent = true;
        desc = "Format buffer or range";
      };
    }
    {
      mode = "n";
      key = "<leader>li";
      action = "<cmd>ConformInfo<CR>";
      options = {
        noremap = true;
        silent = true;
        desc = "Conform formatter info";
      };
    }
  ];
}
