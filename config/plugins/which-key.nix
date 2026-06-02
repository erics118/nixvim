{ utils, ... }:
let
  inherit (utils) mkMap;
in
{
  plugins.which-key = {
    enable = true;
    settings = {
      replace = {
        "<space>" = "󱁐 ";
        "<leader>" = "󱁐 ";
        "<bs>" = "󰌍 ";
        "<cr>" = "󰌑 ";
        "<esc>" = "󱊷 ";
        "<tab>" = "󰌒 ";
      };
      win = {
        border = "rounded";
        padding = [
          0
          0
        ];
      };
    };
  };

  keymaps = [
    (mkMap [ "n" "v" ] "<leader>gd" "<cmd>Gvdiffsplit<CR>" "Git diff")
    (mkMap [ "n" "v" ] "<leader>ng" "<cmd>Neogit<cr>" "Neogit")
  ];

  # Group labels for <leader> prefixes (which-key v3 API).
  extraConfigLua = ''
    require("which-key").add({
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
      { "<leader>f", group = "Telescope" },
      { "<leader>g", group = "Fugitive" },
      { "<leader>h", group = "Gitsigns" },
      { "<leader>l", group = "LSP" },
      { "<leader>n", group = "Neogit" },
      { "<leader>r", group = "Rename" },
      { "<leader>s", group = "Search" },
      { "<leader>t", group = "Toggle" },
      { "<leader>w", group = "Workspace" },
      { "<leader>x", group = "Trouble" },
    })
  '';
}
