{
  config,
  utils,
  ...
}:
let
  name = "lualine";
in
{
  assertions = [
    (utils.requireDependencies config name [
      "web-devicons"
      "navic"
    ])
  ];

  # Enable the lualine plugin
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        icons_enabled = true;
        theme = "catppuccin";
        component_separators = {
          left = "";
          right = "";
        };
        section_separators = {
          left = "";
          right = "";
        };
        always_divide_middle = true;
        globalstatus = true;
        refresh = {
          statusline = 1000;
          tabline = 1000;
          winbar = 1000;
        };
      };
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          "branch"
          "diff"
          "diagnostics"
        ];
        lualine_c = [ "searchcount" ];
        lualine_x = [ "filetype" ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
      winbar = {
        lualine_c = [ "navic" ];
        lualine_x = [
          {
            __unkeyed-1 = {
              __raw = ''
                function()
                  return "  "
                end
              '';
            };
            cond = {
              __raw = ''
                function()
                  local present, navic = pcall(require, "nvim-navic")
                  if not present then
                    return false
                  end
                  return navic.is_available()
                end
              '';
            };
          }
        ];
      };
    };
  };

  # Enable and configure nvim-navic
  plugins.navic = {
    enable = true;
    settings = {
      highlight = true;
      separator = " ";
      icons = {
        File = " ";
        Module = " ";
        Namespace = " ";
        Package = " ";
        Class = " ";
        Method = " ";
        Property = " ";
        Field = " ";
        Constructor = " ";
        Enum = " ";
        Interface = " ";
        Function = " ";
        Variable = " ";
        Constant = " ";
        String = " ";
        Number = " ";
        Boolean = " ";
        Array = " ";
        Object = " ";
        Key = " ";
        Null = " ";
        EnumMember = " ";
        Struct = " ";
        Event = " ";
        Operator = " ";
        TypeParameter = " ";
      };
    };
  };

}
