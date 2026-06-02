let
  ignoredUiFiletypes = import ../shared/ignored-ui-filetypes.nix;
  ignoredFtLua = builtins.concatStringsSep ", " (builtins.map builtins.toJSON ignoredUiFiletypes);
in
{
  plugins.dropbar = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufNewFile"
    ];
    settings = {
      bar.enable.__raw = ''
        function(buf, win, _)
          if not vim.api.nvim_win_is_valid(win) then return false end
          if vim.fn.win_gettype(win) ~= "" then return false end
          local ignored = { ${ignoredFtLua} }
          return not vim.tbl_contains(ignored, vim.bo[buf].filetype)
        end
      '';
    };
  };
}
