{
  # respect .editorconfig files
  editorconfig.enable = true;

  opts = {
    # enable mouse support
    mouse = "a";

    # show line numbers
    number = true;
    relativenumber = true;

    # use system clipboard
    clipboard = "unnamedplus";

    # scroll offsets
    scrolloff = 5;
    sidescrolloff = 15;

    # always show status
    laststatus = 3;

    # always show tab line (bufferline)
    showtabline = 2;

    # completion height
    pumheight = 15;

    # hide command line unless needed
    cmdheight = 0;

    # split directions
    splitbelow = true;
    splitright = true;
    wrap = false;
    ignorecase = true;
    smartcase = true;

    # word boundaries
    iskeyword = "@,48-57,_,192-255";

    # tab settings
    shiftwidth = 4;
    tabstop = 4;
    softtabstop = 4;
    expandtab = true;
    smartindent = true;

    # always show 1 column of sign column (gitsigns, etc.)
    signcolumn = "yes:1";

    # true colors
    termguicolors = true;
  };

  # Custom border characters (rounded)
  extraConfigLua = ''
    vim.g.bc = {
      style = "rounded",
      vert = "│",
      vertleft = "┤",
      vertright = "├",
      horiz = "─",
      horizup = "┴",
      horizdown = "┬",
      verthoriz = "┼",
      topleft = "╭",
      topright = "╮",
      botleft = "╰",
      botright = "╯"
    }

    vim.opt.fillchars:append({
      horiz = vim.g.bc.horiz,
      horizup = vim.g.bc.horizup,
      horizdown = vim.g.bc.horizdown,
      vert = vim.g.bc.vert,
      vertright = vim.g.bc.vertright,
      vertleft = vim.g.bc.vertleft,
      verthoriz = vim.g.bc.verthoriz
    })
  '';
}
