{ utils, ... }: {
  keymaps = [ (utils.mkMap "n" "<leader>tc" "<cmd>Copilot toggle<CR>" "Toggle Copilot") ];

  plugins.copilot-lua = {
    enable = true;
    lazyLoad.settings.event = "InsertEnter";

    settings = {
      panel = {
        enabled = false;
      };
      should_attach.__raw = ''
        function(bufnr, bufname)
          if not vim.bo[bufnr].buflisted then
            return false
          end
          if vim.bo[bufnr].buftype ~= "" then
            return false
          end
          local name = vim.fn.fnamemodify(bufname, ":t")
          if name:match("^%.env") then
            return false
          end
          if bufname:match("/secrets/") then
            return false
          end
          return true
        end
      '';
      suggestion = {
        enabled = true;
        auto_trigger = true;
        debounce = 75;
        keymap = {
          accept = "<C-J>";
        };
      };
      filetypes = {
        yaml = true;
        markdown = false;
        help = false;
        gitcommit = false;
        gitrebase = false;
        hgcommit = false;
        svn = false;
        cvs = false;
        "." = true;
      };
      copilot_node_command = "node";
    };
  };
}
