{
  plugins.web-devicons = {
    enable = true;
  };

  # Custom devicons setup. Colors are hardcoded catppuccin mocha hex values
  # so this runs independently of catppuccin's load order.
  extraConfigLua = ''
    local devicons = require("nvim-web-devicons")
    local justfile = {
      icon = "󱚣",
      name = "Justfile",
      color = "#fab387", -- mocha peach
    }
    devicons.setup({
      override_by_extension = {
        ["astro"] = {
          icon = "",
          name = "Astro",
          color = "#f38ba8", -- mocha red
        },
        ["norg"] = {
          icon = "",
          name = "Neorg",
          color = "#a6e3a1", -- mocha green
        },
      },
      override_by_filename = {
        [".envrc"] = {
          icon = "",
          name = "envrc",
          color = "#f9e2af", -- mocha yellow
        },
        [".editorconfig"] = {
          icon = "",
          name = "EditorConfig",
          color = "#a6e3a1", -- mocha green
        },
        [".luacheckrc"] = {
          icon = "󰢱",
          name = "LuacheckRC",
          color = "#89b4fa", -- mocha blue
        },
        [".Justfile"] = justfile,
        [".justfile"] = justfile,
        ["Justfile"] = justfile,
        ["justfile"] = justfile,
      },
    })
  '';
}
