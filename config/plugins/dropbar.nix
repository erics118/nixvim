{
  plugins.dropbar = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPost"
      "BufNewFile"
    ];
    settings = {
      bar.enable.__raw = ''
        function(_, win, _)
          return vim.api.nvim_win_is_valid(win) and vim.fn.win_gettype(win) == ""
        end
      '';
    };
  };
}
