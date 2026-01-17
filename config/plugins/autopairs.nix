{
  config,
  helpers,
  ...
}:
let
  name = "nvim-autopairs";
in
{
  # assertions = [
  #   (helpers.requireDependencies config name [
  #     "cmp"
  #     "treesitter"
  #   ])
  # ];

  plugins.cmp.enable = true;

  # Enable nvim-autopairs
  plugins.${name} = {
    enable = true;
    settings = {
      # You can add additional autopairs settings here if needed
      check_ts = true; # Example: enable treesitter integration
    };
  };

  # The integration logic to add parentheses after selecting a function/method
  extraConfigLua = ''
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  '';
}
