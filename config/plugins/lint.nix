{
  plugins.lint = {
    enable = true;
    lintersByFt = {
      nix = [
        "statix"
        "deadnix"
      ];
      sh = [ "shellcheck" ];
      bash = [ "shellcheck" ];
      zsh = [ "shellcheck" ];
      dockerfile = [ "hadolint" ];
      markdown = [ "markdownlint-cli2" ];
    };
  };
}
