{ utils, ... }: {
  plugins.colorizer =
    let
      filetypes = [
        "javascript"
        "javascriptreact"
        "typescript"
        "typescriptreact"
        "python"
        "sh"
        "bash"
        "zsh"
        "fish"
        "html"
        "css"
        "scss"
        "json"
        "jsonc"
      ];
    in
    {
      enable = true;
      lazyLoad.settings = {
        ft = filetypes;
        cmd = "ColorizerToggle";
      };
      settings = {
        # other filetypes stay off until toggled with <leader>tC
        inherit filetypes;
        user_default_options = {
          RGB = true;
          RRGGBB = true;
          names = false;
          RRGGBBAA = true;
          mode = "background";
          tailwind = "both";
          virtualtext = " ";
        };
      };
    };

  keymaps = [ (utils.mkMap "n" "<leader>tC" "<cmd>ColorizerToggle<CR>" "Toggle colorizer") ];
}
