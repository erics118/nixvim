{
  imports = [
    ./settings.nix
    ./keymaps.nix
    ./perf.nix
    ./autocmds.nix
    ./lsp.nix

    # Plugins
    ./plugins/alpha.nix
    ./plugins/autopairs.nix
    ./plugins/bufferline.nix
    ./plugins/catppuccin.nix
    ./plugins/colorizer.nix
    ./plugins/copilot.nix
    ./plugins/devicons.nix
    ./plugins/editor.nix
    ./plugins/fidget.nix
    ./plugins/git.nix
    ./plugins/indent-blankline.nix
    ./plugins/lualine.nix
    ./plugins/notify.nix
    ./plugins/nvim-tree.nix
    ./plugins/spectre.nix
    ./plugins/telescope.nix
    ./plugins/terminal.nix
    ./plugins/treesitter.nix
    ./plugins/which-key.nix
  ];
}
