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
        fish = [ "fish_indent" ];

        javascript = [ "prettier" ];
        javascriptreact = [ "prettier" ];
        typescript = [ "prettier" ];
        typescriptreact = [ "prettier" ];
        astro = [ "prettier" ];
        css = [ "prettier" ];
        html = [ "prettier" ];
        json = [ "prettier" ];
        jsonc = [ "prettier" ];
        yaml = [ "prettier" ];
        markdown = [ "prettier" ];

        toml = [ "taplo" ];
        cmake = [ "gersemi" ];
        python = [ "black" ];
        go = [ "gofmt" ];
        rust = [ "rustfmt" ];
        tex = [ "latexindent" ];
        ocaml = [ "ocamlformat" ];
        c = [ "clang_format" ];
        cpp = [ "clang_format" ];
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
