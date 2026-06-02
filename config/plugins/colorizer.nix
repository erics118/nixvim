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
    }; # #FF0000, #FF0000FF, rgb(255,0,0), rgba(255,0,0,1)
    # #beefed
    #feeded
    #deadbeef
  };
}
