{ utils, ... }:
let
  inherit (utils) mkMap;
in
{
  plugins.toggleterm = {
    enable = true;
    lazyLoad.settings.cmd = [
      "ToggleTerm"
      "TermExec"
    ];
    settings = {
      open_mapping = "[[<C-t>]]";
      shade_terminals = false;
    };
  };

  keymaps = [ (mkMap [ "n" "t" ] "<C-t>" "<cmd>ToggleTerm<CR>" "Toggle terminal") ];
}
