{ utils, ... }:
let
  inherit (utils) mkMap;
in
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

      formatters = {
        latexindent = {
          prepend_args = [ "-l" ];
        };
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
        # shfmt does not understand zsh syntax well enough for safe format-on-save
        zsh = [ ];

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
    (mkMap [ "n" "v" ] "<leader>lf" {
      __raw = "function() require('conform').format({ async = true, lsp_format = 'fallback' }) end";
    } "Format buffer or range")
    (mkMap "n" "<leader>li" "<cmd>ConformInfo<CR>" "Conform formatter info")
  ];
}
