{
  plugins.lint = {
    enable = true;
    lintersByFt = {
      nix = [
        "statix"
        "deadnix"
      ];
      dockerfile = [ "hadolint" ];
      markdown = [ "markdownlint-cli2" ];
    };
  };
}
