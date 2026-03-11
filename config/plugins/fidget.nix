{
  plugins.fidget = {
    enable = true;
    lazyLoad.settings.event = "LspAttach";
    settings = {
      notification = {
        window = {
          winblend = 0;
        };
      };
      progress = {
        display = {
          done_icon = "󰗡";
          progress_icon = {
            pattern = "dots";
          };
        };
        ignore = [
          "copilot"
          "none-ls"
        ];
      };
    };
  };
}
