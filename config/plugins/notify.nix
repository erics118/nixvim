{
  plugins.notify = {
    enable = true;
    settings = {
      timeout = 1000;
      render = "compact";
      stages = "fade";
    };
  };

  extraConfigLua = ''
    vim.notify = require("notify")
  '';
}
