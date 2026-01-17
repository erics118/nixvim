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

  # Clipboard and misc keymaps via which-key
  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>p";
      action = ''"+p'';
      options = {
        desc = "Paste from system clipboard";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>y";
      action = ''"+y'';
      options = {
        desc = "Yank to system clipboard";
      };
    }
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
