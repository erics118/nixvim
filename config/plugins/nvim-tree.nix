{
  config,
  utils,
  ...
}:
let
  name = "nvim-tree";
in
{
  assertions = [
    (utils.requireDependencies config name [
      "web-devicons"
    ])
  ];

  plugins.${name} = {
    enable = true;
    settings = {
      renderer = {
        indent_markers = {
          enable = true;
        };
      };
      diagnostics = {
        enable = true;
      };
      actions = {
        file_popup = {
          open_win_config = {
            border = "rounded";
          };
        };
      };
    };
  };
}
