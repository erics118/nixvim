{

  plugins.cmp.enable = true;
  plugins.treesitter.enable = true;
  plugins.web-devicons.enable = true;

  # Import all your configuration modules here
  imports = [
    ./settings.nix

    ./perf.nix
    ./autocmds.nix

    ./plugins/bufferline.nix
    ./plugins/copilot.nix
    ./plugins/alpha.nix
    ./plugins/lualine.nix
    ./plugins/autopairs.nix

  ];

}
