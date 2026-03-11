let
  ignoredUiFiletypes = import ../shared/ignored-ui-filetypes.nix;
in
{
  plugins.indent-blankline = {
    enable = true;
    luaConfig.post = ''
      local function update_scope_underline_style()
        local scope_hl = vim.api.nvim_get_hl(0, { name = "IblScope", link = false })
        local underline_hl = { underdotted = true }
        if scope_hl.fg then
          underline_hl.sp = scope_hl.fg
        end
        vim.api.nvim_set_hl(0, "@ibl.scope.underline.1", underline_hl)
      end

      update_scope_underline_style()

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("IblScopeUnderlineStyle", { clear = true }),
        callback = update_scope_underline_style,
      })
    '';
    settings = {
      indent = {
        char = "▏";
      };
      scope = {
        enabled = true;
        show_start = false;
        show_end = false;
        show_exact_scope = false;
      };
      exclude = {
        filetypes = ignoredUiFiletypes;
      };
    };
  };
}
