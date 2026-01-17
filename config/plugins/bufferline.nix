{
  config,
  helpers,
  ...
}:
let
  name = "bufferline";
in
{
  assertions = [
    (helpers.requireDependencies config name [
      "web-devicons"
    ])
  ];

  plugins.${name}.enable = true;
}
