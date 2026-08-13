{
  plugins.colorizer = {
    enable = true;
    lazyLoad.settings.event = [
      "BufReadPre"
      "BufNewFile"
    ];
    settings = {
      filetypes = [ "*" ];
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
