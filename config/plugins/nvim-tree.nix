{
  config,
  helpers,
  ...
}:
let
  name = "nvim-tree";
in
{
  assertions = [
    (helpers.requireDependencies config name [
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
