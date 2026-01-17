{
  colorschemes.catppuccin.enable = true;
  colorscheme = "catppuccin";
  # defaultEditor = true;
  # vimDiffAlias = true;

  # lazyLoad.enable = true;

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

    # hide tab line
    showtabline = 0;

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
  };

}
