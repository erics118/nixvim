{ config, utils, ... }:
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
      # $ omitted here so pairs still close when the next char is a closing $
      ignored_next_char.__raw = ''[==[[%w%%%'%[%"%.%`]]==]'';
    };
  };

  # The integration logic to add parentheses after selecting a function/method
  extraConfigLua = ''
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

    local npairs = require('nvim-autopairs')
    local Rule = require('nvim-autopairs.rule')

    -- auto-close math delimiters, tex only
    npairs.add_rules({
      Rule('$', '$', 'tex'),
      Rule('\\[', '\\]', 'tex'),
    })
  '';
}
