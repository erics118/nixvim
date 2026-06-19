{ config, utils, ... }:
let
  name = "bufferline";
in
{
  assertions = [ (utils.requireDependencies config name [ "web-devicons" ]) ];

  plugins.${name} = {
    enable = true;
    settings.highlights.__raw = ''require("catppuccin.special.bufferline").get_theme()'';
  };
}
