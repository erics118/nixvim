{
  plugins.web-devicons = {
    enable = true;
  };

  # Custom devicons setup with catppuccin colors
  extraConfigLua = ''
    local present, C = pcall(function() return require("catppuccin.palettes").get_palette() end)
    if present and C then
      local devicons = require("nvim-web-devicons")
      local justfile = {
        icon = "󱚣",
        name = "Justfile",
        color = C.peach,
      }
      devicons.setup({
        override_by_extension = {
          ["astro"] = {
            icon = "",
            name = "Astro",
            color = C.red,
          },
          ["norg"] = {
            icon = "",
            name = "Neorg",
            color = C.green,
          },
        },
        override_by_filename = {
          [".envrc"] = {
            icon = "",
            name = "envrc",
            color = C.yellow,
          },
          [".editorconfig"] = {
            icon = "",
            name = "EditorConfig",
            color = C.green,
          },
          [".luacheckrc"] = {
            icon = "󰢱",
            name = "LuacheckRC",
            color = C.blue,
          },
          [".Justfile"] = justfile,
          [".justfile"] = justfile,
          ["Justfile"] = justfile,
          ["justfile"] = justfile,
        },
      })
    end
  '';
}
