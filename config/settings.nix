{
  # respect .editorconfig files
  editorconfig.enable = true;

  opts = {
    exrc = true;

    # enable mouse support
    mouse = "a";

    # show line numbers
    number = true;
    relativenumber = true;

    # use system clipboard
    # clipboard = "unnamedplus";

    # scroll offsets
    scrolloff = 5;
    sidescrolloff = 15;

    # always show status
    laststatus = 3;

    # always show tab line (bufferline)
    showtabline = 2;

    # completion height
    pumheight = 15;

    # idle delay for CursorHold and swap writes
    updatetime = 250;

    # default border for floating windows (hover, signature help, etc.)
    winborder = "rounded";

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
    shiftwidth = 2;
    tabstop = 2;
    softtabstop = 2;
    expandtab = true;
    smartindent = true;

    # always show 1 column of sign column (gitsigns, etc.)
    signcolumn = "yes:1";

    # true colors
    termguicolors = true;
  };

  # Custom border characters (rounded)
  extraConfigLua = ''
    -- only override clipboard provider over SSH; locally use pbcopy/pbpaste (or xclip)
    if vim.env.SSH_TTY ~= nil then
      vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
          ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
          ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
        paste = {
          ['+'] = function() return { vim.fn.split(vim.fn.getreg('"'), '\n'), vim.fn.getregtype('"') } end,
          ['*'] = function() return { vim.fn.split(vim.fn.getreg('"'), '\n'), vim.fn.getregtype('"') } end,
        },
      }
    end

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

  extraConfigVim = ''
    let g:yaml_recommended_style = 0
  '';
}
