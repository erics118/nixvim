{
  config,
  utils,
  ...
}:
let
  name = "nvim-autopairs";
in
{
  assertions = [
    (utils.requireDependencies config name [
      "cmp"
      "treesitter"
    ])
  ];

  # Enable nvim-autopairs
  plugins.${name} = {
    enable = true;
    settings = {
      check_ts = true; # enable treesitter integration
    };
  };

  # The integration logic to add parentheses after selecting a function/method
  extraConfigLua = ''
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
  '';
}
