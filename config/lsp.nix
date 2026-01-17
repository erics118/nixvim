{
  plugins.lspconfig.enable = true;

  lsp.servers = {
    html.enable = true;
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
}
