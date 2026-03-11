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
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gd";
      action = "<cmd>Gvdiff!<CR>";
      options = {
        desc = "Git diff";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ng";
      action = "<cmd>Neogit<cr>";
      options = {
        desc = "Neogit";
      };
    }
  ];
}
