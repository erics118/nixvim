{
  colorschemes.catppuccin.enable = true;
  colorscheme = "catppuccin";
  # defaultEditor = true;

  lsp.servers = {
    jsonls.enable = true;
    dockerls.enable = true;
    bashls.enable = true;
    gopls.enable = true;
    yamlls.enable = true;
    lua_ls.enable = true;
    ocamllsp.enable = true;
    nixd.enable = true;
    pylsp.enable = true;
    clangd.enable = true;
    ts_ls.enable = true;
  };

  # lazyLoad.enable = true;

  plugins = {
    # lazy loading
    lz-n = {
      enable = true;
    };

    lspconfig = {
      enable = true;
    };

    copilot-lua = {
      enable = true;
      settings = {
        panel = {
          enabled = false;
        };
        suggestion = {
          enabled = true;
          auto_trigger = true;
          debounce = 75;
          keymap = {
            accept = "<C-J>";
          };
        };
        filetypes = {
          yaml = true;
          markdown = false;
          help = false;
          gitcommit = false;
          gitrebase = false;
          hgcommit = false;
          svn = false;
          cvs = false;
          "." = false;
        };
        copilot_node_command = "node";
        server_opts_overrides = { };
      };
    };
  };
}
