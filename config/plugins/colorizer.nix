{
  plugins.colorizer = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPre"
      "BufNewFile"
    ];
    settings = {
      filetypes = {
        __unkeyed-1 = "*";
      };
      user_default_options = {
        RGB = true;
        RRGGBB = true;
        names = false;
        RRGGBBAA = true;
        mode = "background";
        tailwind = "both";
        virtualtext = " ";
      };
    };
  };
}
