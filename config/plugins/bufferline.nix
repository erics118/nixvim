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

  plugins.${name}.enable = true;
}
