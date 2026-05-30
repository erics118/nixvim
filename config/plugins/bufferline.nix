{
  config,
  utils,
  ...
}:
let
  name = "bufferline";
in
{
  assertions = [
    (utils.requireDependencies config name [
      "web-devicons"
    ])
  ];

  plugins.${name} = {
    enable = true;
    settings.highlights = {
      fill.bg.__raw = ''vim.api.nvim_get_hl(0, { name = "Normal" }).bg'';
      background.bg.__raw = ''vim.api.nvim_get_hl(0, { name = "Normal" }).bg'';
    };
  };
}
