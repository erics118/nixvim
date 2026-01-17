{
  plugins.indent-blankline = {
    enable = true;
    settings = {
      indent = {
        char = "▏";
      };
      exclude = {
        filetypes = [
          "alpha"
          "fugitive"
          "help"
          "lazy"
          "NeogitCommitView"
          "NeogitConsole"
          "NeogitStatus"
          "NvimTree"
          "TelescopePrompt"
          "Trouble"
        ];
      };
    };
  };
}
